package main
import (
  "encoding/json"
  "fmt"
  "net/http"
  "os"
)
// VERSION is injected at build time via -ldflags
var VERSION = "dev"
func main() {
  // Support --healthcheck for Docker HEALTHCHECK CMD
  if len(os.Args) > 1 && os.Args[1] == "--healthcheck" {
    resp, err := http.Get("http://localhost:8080/health")
    if err != nil || resp.StatusCode != 200 { os.Exit(1) }
    os.Exit(0)
  }
  http.HandleFunc("/health", healthHandler)
  http.HandleFunc("/api/ping", pingHandler)
  fmt.Printf("myapp %s listening on :8080\n", VERSION)
  http.ListenAndServe(":8080", nil)
}
func healthHandler(w http.ResponseWriter, r *http.Request) {
  json.NewEncoder(w).Encode(map[string]string{
    "status":  "ok",
    "version": VERSION,
  })
}
func pingHandler(w http.ResponseWriter, r *http.Request) {
  json.NewEncoder(w).Encode(map[string]bool{"pong": true})
}