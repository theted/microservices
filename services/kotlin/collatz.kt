// One hailstone step from Kotlin, served by the JDK's built-in HTTP server.
import com.sun.net.httpserver.HttpServer
import java.net.InetSocketAddress

fun step(n: Long): Long = if (n % 2 == 0L) n / 2 else 3 * n + 1

fun main() {
    val server = HttpServer.create(InetSocketAddress(8000), 0)
    server.createContext("/") { exchange ->
        val n = exchange.requestURI.rawQuery
            ?.split("&")
            ?.firstOrNull { it.startsWith("n=") }
            ?.removePrefix("n=")
            ?.toLongOrNull()
            ?.takeIf { it > 0 }
        val (status, body) = if (n != null) 200 to step(n).toString() else 400 to "need ?n=<positive integer>"
        val bytes = body.toByteArray()
        exchange.responseHeaders.set("Content-Type", "text/plain")
        exchange.sendResponseHeaders(status, bytes.size.toLong())
        exchange.responseBody.use { it.write(bytes) }
    }
    server.start()
    println("Kotlin is listening on :8000")
}
