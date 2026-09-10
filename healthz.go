package main

import "net/http"

// healthz answers the Kubernetes probes and the DEV smoke Job. The body
// is part of the contract: the smoke Job greps for it.
func healthz(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusOK)
	_, _ = w.Write([]byte("okk"))
}
