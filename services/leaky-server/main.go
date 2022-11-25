package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"net/http/pprof"
	"time"
)

func main() {
	if err := run(); err != nil {
		log.Fatal(err)
	}
}

func listenToContext(ctx context.Context) {
	select {
	case <-time.After(7 * time.Minute):
	case <-ctx.Done():
		fmt.Println("request is done being served and context is closed")
	}
}

func run() error {
	mux := http.NewServeMux()

	mux.HandleFunc("/leak", func(w http.ResponseWriter, r *http.Request) {
		go listenToContext(r.Context())

		w.Write([]byte("request recieved"))
	})

	mux.HandleFunc("/debug/pprof/", pprof.Index)
	mux.HandleFunc("/debug/pprof/profile", pprof.Profile)
	mux.HandleFunc("/debug/pprof/symbol", pprof.Symbol)
	mux.HandleFunc("/debug/pprof/cmdline", pprof.Cmdline)

	server := &http.Server{
		Addr:    ":8081",
		Handler: mux,
	}

	return server.ListenAndServe()
}
