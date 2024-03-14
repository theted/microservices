package main

import (
	"fmt"
	"net/http"
)

func enableCors(w *http.ResponseWriter) {
(   *w).Header().Set("Access-Control-Allow-Origin", "*")
}

func helloWorld(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    fmt.Fprintf(w, "Hello from Go!")
}

func main() {
    fmt.Println("Server is running on port 8090")
    http.HandleFunc("/", helloWorld)
    http.ListenAndServe(":8090", nil)
}
