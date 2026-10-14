# One hailstone step from Ruby, on a plain TCPServer from the standard library.
require "socket"

def step(n) = n.even? ? n / 2 : 3 * n + 1

$stdout.sync = true
server = TCPServer.new("0.0.0.0", 8000)
puts "Ruby is listening on :8000"

loop do
  Thread.start(server.accept) do |client|
    request_line = client.gets.to_s
    while (header = client.gets) && header != "\r\n"; end

    n = request_line[/[?&]n=(\d+)[ &]/, 1].to_i
    status, body = n.positive? ? ["200 OK", step(n).to_s] : ["400 Bad Request", "need ?n=<positive integer>"]
    client.write "HTTP/1.0 #{status}\r\nContent-Type: text/plain\r\nContent-Length: #{body.bytesize}\r\n\r\n#{body}"
  ensure
    client.close
  end
end
