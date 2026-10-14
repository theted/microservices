// One hailstone step over HTTP, in C with nothing but POSIX sockets.
#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

static unsigned long step(unsigned long n) {
    return n % 2 == 0 ? n / 2 : 3 * n + 1;
}

// Finds n in "GET /?n=27 HTTP/1.0", looking only at the request line.
static unsigned long query_n(const char *request) {
    for (const char *p = request; *p && *p != '\r' && *p != '\n'; p++) {
        if ((*p == '?' || *p == '&') && p[1] == 'n' && p[2] == '=' && p[3] >= '0' && p[3] <= '9') {
            return strtoul(p + 3, NULL, 10);
        }
    }
    return 0;
}

int main(void) {
    signal(SIGPIPE, SIG_IGN);

    int server = socket(AF_INET, SOCK_STREAM, 0);
    int yes = 1;
    setsockopt(server, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes);
    struct sockaddr_in addr = {
        .sin_family = AF_INET,
        .sin_port = htons(8000),
        .sin_addr.s_addr = htonl(INADDR_ANY),
    };
    if (bind(server, (struct sockaddr *)&addr, sizeof addr) || listen(server, 128)) {
        perror("bind/listen");
        return 1;
    }
    puts("C is listening on :8000");
    fflush(stdout);

    for (;;) {
        int client = accept(server, NULL, NULL);
        if (client < 0) {
            continue;
        }
        char request[4096];
        ssize_t got = read(client, request, sizeof request - 1);
        if (got > 0) {
            request[got] = '\0';
            unsigned long n = query_n(request);
            if (n) {
                dprintf(client, "HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\n%lu", step(n));
            } else {
                dprintf(client, "HTTP/1.0 400 Bad Request\r\nContent-Type: text/plain\r\n\r\n"
                                "need ?n=<positive integer>");
            }
        }
        close(client);
    }
}
