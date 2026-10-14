// The runner is the only HTTP server in the project. Every language container
// runs it in front of that language's program, so each program stays a plain
// "read n, print the next number" and no language is timed on its web server.
package main

import (
	"bytes"
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
	"syscall"
	"time"
)

var integer = regexp.MustCompile(`-?\d+`)

func main() {
	command := os.Getenv("STEP_CMD")
	timeout := 10 * time.Second
	if seconds, err := strconv.Atoi(os.Getenv("STEP_TIMEOUT")); err == nil {
		timeout = time.Duration(seconds) * time.Second
	}

	http.HandleFunc("GET /", func(w http.ResponseWriter, r *http.Request) {
		n, err := strconv.ParseUint(r.URL.Query().Get("n"), 10, 32)
		if err != nil || n == 0 {
			http.Error(w, "need ?n=<positive integer>", http.StatusBadRequest)
			return
		}
		digits := strconv.FormatUint(n, 10)

		ctx, cancel := context.WithTimeout(r.Context(), timeout)
		defer cancel()
		var stdout, stderr bytes.Buffer
		cmd := exec.CommandContext(ctx, "/bin/sh", "-c", command)
		cmd.Env = append(os.Environ(), "N="+digits)
		cmd.Stdin = strings.NewReader(digits + "\n")
		cmd.Stdout, cmd.Stderr = &stdout, &stderr
		// Run it in its own process group, so a timeout takes down everything it started.
		cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
		cmd.Cancel = func() error { return syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL) }
		cmd.WaitDelay = time.Second

		started := time.Now()
		err = cmd.Run()
		took := time.Since(started)

		// Whatever the program prints, the last integer is its answer.
		found := integer.FindAll(stdout.Bytes(), -1)
		if err != nil || len(found) == 0 {
			log.Printf("n=%s: %v %s", digits, err, strings.TrimSpace(stderr.String()))
			http.Error(w, fmt.Sprintf("%s: %v", command, err), http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "text/plain")
		w.Header().Set("Server-Timing", fmt.Sprintf("run;dur=%.2f", took.Seconds()*1000))
		w.Write(found[len(found)-1])
	})

	log.Printf("running %q for every request on :8000", command)
	log.Fatal(http.ListenAndServe(":8000", nil))
}
