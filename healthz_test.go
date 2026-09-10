package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealthzBody(t *testing.T) {
	rec := httptest.NewRecorder()
	healthz(rec, httptest.NewRequest(http.MethodGet, "/healthz", nil))
	if rec.Code != http.StatusOK {
		t.Fatalf("status %d", rec.Code)
	}
	if got := rec.Body.String(); got != "ok" {
		t.Fatalf("body %q, want %q", got, "ok")
	}
}
