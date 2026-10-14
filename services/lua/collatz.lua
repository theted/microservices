-- One hailstone step from Lua 5.4, with LuaSocket doing the networking.
local socket = require("socket")

local function step(n)
  if n % 2 == 0 then return n // 2 end
  return 3 * n + 1
end

local server = assert(socket.bind("0.0.0.0", 8000))
io.stdout:setvbuf("line")
print("Lua is listening on :8000")

while true do
  local client = server:accept()
  client:settimeout(5)
  local request = client:receive("*l") or ""
  repeat
    local header = client:receive("*l")
  until not header or header == ""

  local n = tonumber(request:match("[?&]n=(%d+)[ &]"))
  local status, body = "400 Bad Request", "need ?n=<positive integer>"
  if n and n > 0 then
    status, body = "200 OK", tostring(step(n))
  end
  client:send(("HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s"):format(status, #body, body))
  client:close()
end
