# Hailstone Relay

A deliberately over-engineered microservice setup. Seventy-eight languages, each in its own container, pass one number around. Each one computes **one Collatz step**: even numbers are halved, odd ones become 3n + 1. The web client hands the current number to a random language, takes the answer, and passes it on until the number falls to 1. Then it starts again from a new random seed.

Nobody has proven that every starting number reaches 1. So this is an unsolved conjecture, spread over COBOL, INTERCAL, a spreadsheet and a few lines of assembly.

## Why?

Why not!

## Run it

```sh
docker compose up --build -d   # the first build takes a long while: 78 images, several GB
open http://localhost:8080
scripts/smoke.sh               # asks every language a few questions and checks the answers
```

The client draws the current chain as a hailstone chart, logs every hop, and keeps a leaderboard. **Click any language** to read its code: in the leaderboard, in the log, or as a dot on the chart.

The client also referees: it checks every answer itself. A wrong answer shows up as "🚨 Forth lied!" and the relay carries on with the right number. A service that is down gets a 💀 and is retried 20 seconds later.

Seeds stay below 10,000. The largest value any of them reaches is 27,114,424 (seed 9663), so the languages limited to 32-bit integers can keep up.

## One program per language, one server for all

Each language folder holds a single small program that reads n from stdin and prints the next number. That program is the whole point, and it's what the viewer opens on. None of the languages know about HTTP.

The HTTP part is `runner/`, about 60 lines of Go and the only web server in the project. Every language image copies the same runner binary, which listens on :8000 and runs that language's program once per request. Because everyone is served and timed the same way, the leaderboard compares languages rather than web servers. The time it shows is the time it takes to run the program once: start up, read n, compute, print. That is why the leaderboard looks the way it does. Compiled binaries take 1–5 ms (assembly, C, Fortran and Rust lead), scripting languages take 5–100 ms, and the JVM languages about 80. The tail is the funny part: a LibreOffice spreadsheet (about 320 ms) beats Raku, Julia, Erlang, Elixir and, by a wide margin, PowerShell (over a second).

```
browser ──▶ gateway (nginx, 127.0.0.1:8080)
              ├─ /                 → web/  (the client)
              ├─ /src/…            → services/ and runner/, read-only (the code viewer)
              └─ /svc/<id>/?n=27   → <id> container: runner :8000 ──▶ the program, once
```

- **Contract:** the program gets n on stdin, and in `$N` for languages that would rather not read stdin (Forth, TeX, Nix…). **The last integer it prints is the answer.** A C64 that prints `? 82` is fine, and so is INTERCAL's helper script, which turns Roman numerals back into digits.
- **Runner:** validates `?n=` (junk gets a 400), runs `$STEP_CMD` through `sh -c`, and returns the answer. It reports how long the program took in a `Server-Timing` header, which the client uses for the leaderboard.
- **Gateway:** `gateway/nginx.conf` resolves `<id>` through Docker's DNS on every request. A new language needs no gateway change, and a stopped one is a 502 instead of a gateway that refuses to start.
- **Sharing the runner:** compose builds it as a service that never starts (`scale: 0`), and each language's build gets it as an extra build context: `COPY --from=runner /runner /usr/local/bin/runner`.

## The languages

| Tier | Languages |
|---|---|
| Classic | Go, Python, PHP, C#, TypeScript, JavaScript, Rust, Java, Kotlin, C, C++, Ruby, Perl, Bash, Lua, Swift, Zig, Dart, Julia, R, Elixir, Erlang, OCaml, F#, PowerShell, Nim, Crystal, D, Tcl |
| Esolang | ArnoldC, LOLCODE, Shakespeare, Brainfuck, Befunge-93, Whitespace, INTERCAL, Rockstar, Emojicode |
| Retro | COBOL, Fortran 77, C64 BASIC, Forth, Pascal, ALGOL 68, Ada, Logo, dc, REXX, VB.NET |
| Not a language | TeX, SQL, gawk, jq, sed, PostScript, Vim script, Spreadsheet, Nix, OpenTofu, m4 |
| Mind-bender | Prolog, APL, x86-64 asm, Haskell, WebAssembly, Raku, Uiua, Lean 4, Standard ML |
| Lisp | Emacs Lisp, Guile Scheme, Clojure (babashka), Racket, Common Lisp, Janet, Hy, Fennel, PicoLisp |

Some highlights:

- **Brainfuck** runs on 8-bit cells, so it does long arithmetic one decimal digit at a time, ten cells per digit.
- **sed** has no numbers at all. It halves and triples by text substitution, carrying remainders as marker characters.
- **INTERCAL** reads its input spelled out in English (`TWO SEVEN`) and answers in Roman numerals, with overbars meaning ×1000.
- **Whitespace**: only spaces, tabs and newlines are code, so the visible words in the file are comments. The viewer draws the invisible program.
- **Java** is the Enterprise Edition: a singleton strategy factory picks between halving and tripling.
- **C++** has the compiler check `static_assert(steps_to_one(27) == 111)` before the binary even exists.
- **Lean 4** proves that its step function halves every even number, then compiles to C.
- **Rockstar** is a power ballad: `Burn your heart with 10`.
- **Emojicode** is written entirely in emoji, built with the language's last release, from 2019.
- **Spreadsheet** opens a LibreOffice Calc document for every number, and still beats five real programming languages.

The commit before this layout (d4bb8a2) has the earlier version, where most languages ran their own HTTP server. It includes an HTTP server in raw assembly, one in pure Bash using its `accept` builtin, and one in Emojicode.

## Add a language

1. Create `services/<id>/` with your program, plus a Dockerfile that installs the language, copies in the runner and the program, and says how to run it:

   ```dockerfile
   FROM alpine:3.24
   RUN apk add --no-cache lua5.4
   COPY --from=runner /runner /usr/local/bin/runner
   COPY collatz.lua /app/
   ENV STEP_CMD="lua5.4 /app/collatz.lua"
   CMD ["runner"]
   ```

2. Add it to `docker-compose.yml`: `<id>: { build: { context: ./services/<id>, <<: *language } }`.
3. Add it to `web/services.json`: id, name, tier, the program's file name as `source`, a highlight.js language in `hl` if there is one, and a one-line blurb.
4. `docker compose up -d --build <id> && scripts/smoke.sh`

## Backlog

- **Esolangs:** Piet (the program is a PNG), Ook!, Chef (the program is a recipe), Malbolge (no)
- **Retro:** Smalltalk, Modula-2, QBasic in DOSBox, 6502 assembly on an emulated C64
- **Mind-benders:** J, BQN, K, Agda, Idris, Gleam
- **Not a language:** GNU Make, CSS (somehow), a Dockerfile that computes at build time
