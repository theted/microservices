// One hailstone step. Blazingly fast 🚀, memory safe, zero dependencies.
use std::io::{BufRead, BufReader, Write};
use std::net::{TcpListener, TcpStream};
use std::thread;

fn step(n: u64) -> u64 {
    if n % 2 == 0 { n / 2 } else { 3 * n + 1 }
}

fn query_n(request_line: &str) -> Option<u64> {
    let target = request_line.split_whitespace().nth(1)?;
    let (_, query) = target.split_once('?')?;
    query
        .split('&')
        .find_map(|pair| pair.strip_prefix("n="))
        .and_then(|n| n.parse().ok())
        .filter(|&n| n > 0)
}

fn handle(stream: TcpStream) -> std::io::Result<()> {
    let mut reader = BufReader::new(&stream);
    let mut request_line = String::new();
    reader.read_line(&mut request_line)?;
    let mut header = String::new();
    while reader.read_line(&mut header)? > 2 {
        header.clear();
    }

    let (status, body) = match query_n(&request_line) {
        Some(n) => ("200 OK", step(n).to_string()),
        None => ("400 Bad Request", "need ?n=<positive integer>".to_string()),
    };
    write!(
        &stream,
        "HTTP/1.0 {status}\r\nContent-Type: text/plain\r\nContent-Length: {}\r\n\r\n{body}",
        body.len()
    )
}

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("0.0.0.0:8000")?;
    println!("Rust is listening on :8000");
    for stream in listener.incoming().flatten() {
        thread::spawn(move || handle(stream));
    }
    Ok(())
}
