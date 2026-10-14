# Hailstone Relay

A deliberately over-engineered microservice setup. Seventy-eight languages, each in its own container, pass one number around. Each service computes **one Collatz step**: even numbers are halved, odd ones become 3n + 1. The web client hands the current number to a random language, takes the answer, and passes it on until the number falls to 1. Then it starts again from a new random seed.

Nobody has proven that every starting number reaches 1. So this is an unsolved conjecture, spread over COBOL, INTERCAL, a spreadsheet and an HTTP server written in assembly.

## Why?

Why not!

## Run it

```sh
docker compose up --build -d   # the first build takes a long while: 78 images, several GB
open http://localhost:8080
scripts/smoke.sh               # asks every language a few questions and checks the answers
```

The client draws the current chain as a hailstone chart. Every hop goes into a log, and a leaderboard tracks how fast each language answers. **Click any language** to read its source: the leaderboard, the log, or a dot on the chart all open it. The viewer also shows each language's Dockerfile, any helper files, and the shim for the languages that use it.

The client also referees: it checks every answer itself. A wrong answer shows up as "🚨 Forth lied!" and the relay carries on with the right number. A service that is down gets a 💀 and is retried 20 seconds later.

Seeds stay below 10,000. The largest value any of them reaches is 27,114,424 (seed 9663), so the languages limited to 32-bit integers can keep up.

## The languages

🏅 serves HTTP itself. 🩹 never touches a socket, and a shared shim does the HTTP part for it (see below).

| Tier | Languages |
|---|---|
| Classic | Go, Python, PHP, C#, TypeScript, JavaScript, Rust, Java, Kotlin, C, C++ 🩹, Ruby, Perl, Bash, Lua, Swift 🩹, Zig 🩹, Dart, Julia, R, Elixir, Erlang, OCaml, F#, PowerShell, Nim, Crystal, D, Tcl |
| Esolang | ArnoldC 🩹, LOLCODE 🩹, Shakespeare 🩹, Brainfuck 🩹, Befunge-93 🩹, Whitespace 🩹, INTERCAL 🩹, Rockstar 🩹, Emojicode |
| Retro | COBOL, Fortran 77, C64 BASIC, Forth, Pascal, ALGOL 68, Ada, Logo, dc, REXX, VB.NET (all 🩹) |
| Not a language | TeX 🩹, SQL, gawk, jq 🩹, sed 🩹, PostScript 🩹, Vim script 🩹, Spreadsheet 🩹, Nix 🩹, OpenTofu 🩹, m4 🩹 |
| Mind-bender | Prolog, APL 🩹, x86-64 asm, Haskell 🩹, WebAssembly 🩹, Raku, Uiua 🩹, Lean 4 🩹, Standard ML 🩹 |
| Lisp | Emacs Lisp, Guile Scheme, Clojure (babashka), Racket, Common Lisp, Janet, Hy, Fennel, PicoLisp |

Some highlights:

- **Brainfuck** runs on 8-bit cells, so it does long arithmetic one decimal digit at a time, ten cells per digit.
- **sed** has no numbers at all. It halves and triples by text substitution, carrying remainders as marker characters.
- **INTERCAL** reads its input spelled out in English (`TWO SEVEN`) and answers in Roman numerals, with overbars meaning ×1000. `run.sh` translates both ways.
- **Whitespace**: only spaces, tabs and newlines are code, so the visible words in the file are comments. The viewer draws the invisible program.
- **Emojicode** is a native web server written entirely in emoji, compiled with the language's last release, from 2019.
- **Java** is the Enterprise Edition: a singleton strategy factory picks between halving and tripling.
- **C++** has the compiler check `static_assert(steps_to_one(27) == 111)` before the binary even exists.
- **Lean 4** proves that its step function halves every even number, then compiles to C.
- **Bash** is a real web server, using the `accept` builtin from `bash-builtins`. No netcat.
- **Emacs** and **Vim** are both on duty. Emacs serves HTTP itself; Vim writes the answer into a buffer.
- **Spreadsheet** opens a LibreOffice Calc document for every single number, which makes it the slowest service here.
- **x86-64 asm** is an HTTP server made of raw syscalls. Its image is 16 kB; the APL image is 761 MB.

Rough timings per hop: most native servers answer in under 10 ms. Shimmed compiled programs take about 20 ms, TeX about 30, APL about 35, ArnoldC about 100 (the JVM starting up), Shakespeare about 250 and the spreadsheet about 330.

## How it fits together

```
browser ──▶ gateway (nginx, 127.0.0.1:8080)
              ├─ /                 → web/  (the client)
              ├─ /src/…            → services/ and shim/, read-only (the source viewer)
              └─ /svc/<id>/?n=27   → http://<id>:8000/?n=27
```

- **Contract:** `GET /?n=<positive integer>` on port 8000. The answer is the **last integer in the body**, so a C64 that prints `? 82` is fine. Junk input should get a 4xx.
- **Gateway:** `gateway/nginx.conf` resolves `<id>` through Docker's DNS on every request. A new service needs no gateway change, and a stopped one is a 502 instead of a gateway that refuses to start. The one special case is `sql`, because PostgREST serves functions under `/rpc/`.
- **Shim:** `shim/` holds about 40 lines of sh around socat. Each connection runs `$STEP_CMD` with n on stdin and in `$N`, then returns the last integer it printed. Dockerfiles get the shim through compose's `additional_contexts` with `COPY --from=shim . /shim/`.
- **Source viewer:** nginx serves `services/` and `shim/` as plain text, with JSON directory listings, so the client can find every file. Syntax highlighting comes from highlight.js on cdnjs. Without a network connection the code still shows, just uncolored.

## Add a language

1. Create `services/<id>/` with a Dockerfile, in one of two flavors:
   - **Native:** serve the contract above on `:8000`.
   - **Shimmed:** install `socat`, `COPY --from=shim . /shim/`, set `ENV STEP_CMD=...`, and use `CMD ["/shim/serve"]`. Add `<<: *shimmed` to its `build:` in compose. See `services/cobol` for the smallest example.
2. Add it to `docker-compose.yml`.
3. Add it to `web/services.json`: id, name, tier, `native`, the main `source` file, a highlight.js language in `hl` if there is one, and a one-line blurb.
4. `docker compose up -d --build <id> && scripts/smoke.sh`

## Backlog

- **Esolangs:** Piet (the program is a PNG), Ook!, Chef (the program is a recipe), Malbolge (no)
- **Retro:** Smalltalk, Modula-2, QBasic in DOSBox, 6502 assembly on an emulated C64
- **Mind-benders:** J, BQN, K, Agda, Idris, Gleam
- **Not a language:** GNU Make, CSS (somehow), a Dockerfile that computes at build time
