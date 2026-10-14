package main

import (
	"fmt"
	"log"
	"net/http"
	"strconv"
)

func step(n int64) int64 {
	if n%2 == 0 {
		return n / 2
	}
	return 3*n + 1
}

func main() {
	http.HandleFunc("GET /", func(w http.ResponseWriter, r *http.Request) {
		n, err := strconv.ParseInt(r.URL.Query().Get("n"), 10, 64)
		if err != nil || n < 1 {
			http.Error(w, "need ?n=<positive integer>", http.StatusBadRequest)
			return
		}
		fmt.Fprint(w, step(n))
	})
	log.Println("Go is listening on :8000")
	log.Fatal(http.ListenAndServe(":8000", nil))
}
