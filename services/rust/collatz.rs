// One hailstone step in Rust.
fn step(n: u64) -> u64 {
    if n % 2 == 0 { n / 2 } else { 3 * n + 1 }
}

fn main() {
    let mut line = String::new();
    std::io::stdin().read_line(&mut line).unwrap();
    println!("{}", step(line.trim().parse().unwrap()));
}
