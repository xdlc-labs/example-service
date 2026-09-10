package main

import (
	"encoding/json"
	"net/http"
)

// version is stamped by the release pipeline; "dev" for local builds.
var version = "dev"

// versionInfo is what /version returns. The console reads it to show
// which build is serving.
type versionInfo struct {
	Version string `json:"version"`
	Service string `json:"service"`
}

func versionHandler(svc string) http.HandlerFunc {
	return func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(versionInfo{Version: version, Service: svc})
	}
}
