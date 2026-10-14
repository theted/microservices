(* One hailstone step from OCaml, with the Unix library's sockets. *)
let step n = if n mod 2 = 0 then n / 2 else (3 * n) + 1

let query_n request_line =
  match String.split_on_char ' ' request_line with
  | _ :: target :: _ -> (
      match String.index_opt target '?' with
      | None -> None
      | Some i -> (
          String.sub target (i + 1) (String.length target - i - 1)
          |> String.split_on_char '&'
          |> List.find_map (fun pair ->
                 match String.split_on_char '=' pair with
                 | [ "n"; value ] -> int_of_string_opt value
                 | _ -> None)
          |> function
          | Some n when n > 0 -> Some n
          | _ -> None))
  | _ -> None

let serve client =
  let input = Unix.in_channel_of_descr client
  and output = Unix.out_channel_of_descr client in
  let request_line = try String.trim (input_line input) with End_of_file -> "" in
  (try
     while String.trim (input_line input) <> "" do
       ()
     done
   with End_of_file -> ());
  let status, body =
    match query_n request_line with
    | Some n -> ("200 OK", string_of_int (step n))
    | None -> ("400 Bad Request", "need ?n=<positive integer>")
  in
  Printf.fprintf output "HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s"
    status (String.length body) body;
  flush output

let () =
  Sys.set_signal Sys.sigpipe Sys.Signal_ignore;
  let server = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  Unix.setsockopt server Unix.SO_REUSEADDR true;
  Unix.bind server (Unix.ADDR_INET (Unix.inet_addr_any, 8000));
  Unix.listen server 128;
  print_endline "OCaml is listening on :8000";
  while true do
    let client, _ = Unix.accept server in
    (try serve client with Unix.Unix_error _ | Sys_error _ -> ());
    Unix.close client
  done
