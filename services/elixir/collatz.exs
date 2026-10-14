# One hailstone step from Elixir. The BEAM parses HTTP for us: with
# packet: :http_bin, :gen_tcp hands over the request line as a tuple.
defmodule Collatz do
  def step(n) when rem(n, 2) == 0, do: div(n, 2)
  def step(n), do: 3 * n + 1

  def serve(port) do
    {:ok, listener} =
      :gen_tcp.listen(port, [:binary, packet: :http_bin, active: false, reuseaddr: true])

    IO.puts("Elixir is listening on :#{port}")
    accept_loop(listener)
  end

  defp accept_loop(listener) do
    {:ok, socket} = :gen_tcp.accept(listener)
    pid = spawn(fn -> receive do: (:go -> handle(socket)) end)
    :ok = :gen_tcp.controlling_process(socket, pid)
    send(pid, :go)
    accept_loop(listener)
  end

  defp handle(socket) do
    {status, body} =
      with {:ok, {:http_request, :GET, {:abs_path, path}, _version}} <- :gen_tcp.recv(socket, 0),
           :ok <- skip_headers(socket),
           %{"n" => raw} <- URI.decode_query(URI.parse(path).query || ""),
           {n, ""} when n > 0 <- Integer.parse(raw) do
        {"200 OK", Integer.to_string(step(n))}
      else
        _ -> {"400 Bad Request", "need ?n=<positive integer>"}
      end

    :gen_tcp.send(
      socket,
      "HTTP/1.0 #{status}\r\nContent-Type: text/plain\r\nContent-Length: #{byte_size(body)}\r\n\r\n#{body}"
    )

    :gen_tcp.close(socket)
  end

  defp skip_headers(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, :http_eoh} -> :ok
      {:ok, {:http_header, _, _, _, _}} -> skip_headers(socket)
      other -> other
    end
  end
end

Collatz.serve(8000)
