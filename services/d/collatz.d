// One hailstone step from D, with Phobos' std.socket.
import core.sys.posix.signal : signal, SIGPIPE, SIG_IGN;
import std.conv : ConvException, to;
import std.format : format;
import std.regex : matchFirst, regex;
import std.socket;
import std.stdio : stdout, writeln;

long step(long n) {
    return n % 2 == 0 ? n / 2 : 3 * n + 1;
}

void main() {
    signal(SIGPIPE, SIG_IGN);
    auto query = regex(`[?&]n=(\d+)[ &]`);
    auto server = new TcpSocket();
    server.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
    server.bind(new InternetAddress(8000));
    server.listen(128);
    writeln("D is listening on :8000");
    stdout.flush();

    char[4096] buffer;
    while (true) {
        auto client = server.accept();
        scope (exit) client.close();
        auto got = client.receive(buffer[]);
        if (got <= 0) continue;

        auto m = buffer[0 .. got].idup.matchFirst(query);
        long n = 0;
        if (!m.empty) {
            try n = m[1].to!long; catch (ConvException) {}
        }
        client.send(n > 0
            ? format("HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\n%d", step(n))
            : "HTTP/1.0 400 Bad Request\r\nContent-Type: text/plain\r\n\r\nneed ?n=<positive integer>");
    }
}
