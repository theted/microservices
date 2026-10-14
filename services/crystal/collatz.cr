# One hailstone step from Crystal: Ruby's syntax, C's speed, a web server in the stdlib.
require "http/server"

def step(n : Int64) : Int64
  n.even? ? n // 2 : n * 3 + 1
end

server = HTTP::Server.new do |context|
  n = context.request.query_params["n"]?.try(&.to_i64?)
  context.response.content_type = "text/plain"
  if n && n > 0
    context.response.print step(n)
  else
    context.response.status = :bad_request
    context.response.print "need ?n=<positive integer>"
  end
end

server.bind_tcp "0.0.0.0", 8000
puts "Crystal is listening on :8000"
server.listen
