# Hailstone Relay

A deliberately over-engineered microservice setup. Ninety-five languages, each in its own container, pass one number around. Each one computes **one Collatz step**: even numbers are halved, odd ones become 3n + 1. The web client hands the current number to a random language, takes the answer, and passes it on until the number falls to 1. Then it starts again from a new random seed.

Nobody has proven that every starting number reaches 1. So this is an unsolved conjecture, spread over COBOL, INTERCAL, a spreadsheet, an Ansible playbook and a picture.

## Why?

Why not!

## Run it

```sh
docker compose up --build -d   # the first build takes a long while: 95 images, several GB
open http://localhost:8080
scripts/smoke.sh               # asks every language a few questions and checks the answers
```

The client draws the current chain as a hailstone chart, logs every hop, and keeps a leaderboard. **Click any language** to read its code: in the leaderboard, in the log, or as a dot on the chart.

The client also referees: it checks every answer itself. A wrong answer shows up as "🚨 Forth lied!" and the relay carries on with the right number. A service that is down gets a 💀 and is retried 20 seconds later.

Seeds stay below 10,000. The largest value any of them reaches is 27,114,424 (seed 9663), so the languages limited to 32-bit integers can keep up.

## One program per language, one server for all

Each language folder holds a single small program that reads n from stdin and prints the next number. That program is the whole point, and it's what the viewer opens on. None of the languages know about HTTP.

The HTTP part is `runner/`, about 60 lines of Go and the only web server in the project. Every language image copies the same runner binary, which listens on :8000 and runs that language's program once per request. Because everyone is served and timed the same way, the leaderboard compares languages rather than web servers. The time it shows is the time it takes to run the program once: start up, read n, compute, print. That is why the leaderboard looks the way it does. Compiled programs take about 1–5 ms, scripting languages 5–100 ms, and the JVM languages about 80. The fastest program is in ALGOL 60, from 1960, and an emulated 6502 is right behind it. The tail is the funny part: a LibreOffice spreadsheet (about 320 ms) beats an Ansible playbook, Raku, Julia, Erlang, Elixir and, by a wide margin, PowerShell (over a second).

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
| Classic | Go, Python, PHP, C#, TypeScript, JavaScript, Rust, Java, Kotlin, C, C++, Objective-C, Ruby, Perl, Bash, Lua, Swift, Zig, Dart, Julia, R, Elixir, Erlang, OCaml, F#, PowerShell, Nim, Crystal, D, Tcl |
| Esolang | ArnoldC, LOLCODE, Shakespeare, Brainfuck, Ook!, Befunge-93, Whitespace, INTERCAL, Rockstar, Emojicode, Piet |
| Golf | Vyxal, Jelly, GolfScript |
| Retro | COBOL, Fortran 77, ALGOL 60, SNOBOL4, C64 BASIC, 6502 assembly, Forth, Pascal, ALGOL 68, Ada, Logo, dc, REXX, VB.NET |
| Not a language | TeX, SQL, gawk, jq, sed, PostScript, Vim script, Spreadsheet, Nix, OpenTofu, m4, Typst, gnuplot, Maxima, Ansible |
| Mind-bender | Prolog, APL, J, K, x86-64 asm, RISC-V assembly, Haskell, WebAssembly, Raku, Uiua, Factor, Lean 4, Standard ML |
| Lisp | Emacs Lisp, Guile Scheme, Clojure (babashka), Racket, Common Lisp, Janet, Hy, Fennel, PicoLisp |

Some highlights:

- **Piet**'s program is a picture: 13×8 coloured blocks, where every change of colour is a command. Odd numbers make the instruction pointer turn down the page.
- **6502 assembly** runs on an emulated 6502, the CPU of the C64 and the NES. The chip has no multiply instruction, but it does have a decimal mode, so n stays in binary-coded decimal the whole way and tripling is literally n + n + n + 1.
- **RISC-V assembly** is emulated by qemu, on an x86 machine.
- **Golf**: Vyxal's whole program is `₂[½|3*›`, Jelly's is `×3‘$:2$Ḃ?` and GolfScript's is `~.2%{3*)}{2/}if`.
- **Ook!** is the Brainfuck program translated for orang-utans: every command is a pair of `Ook.`, `Ook?` and `Ook!`.
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
- **Ansible** runs a playbook against localhost, doing the arithmetic in Jinja2.
- **Maxima** is a computer algebra system where `step` is a reserved word, so its function is called `hailstone`.

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

- **Esolangs:** Chef (the program is a recipe, but the Perl interpreter only divides in floating point, so it can't tell odd from even without counting), Malbolge (no)
- **Retro:** Simula, Smalltalk, Modula-2, QBasic in DOSBox
- **Mind-benders:** BQN, Agda, Idris, Gleam
- **Not a language:** GNU Make, CSS (somehow)
