package main

import (
	"io"
	"log"
	"net/http"
)

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
}

func run() error {
	mux := http.NewServeMux()

	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		io.WriteString(w, "Hello World")
	})

	server := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	return server.ListenAndServe()
}
