package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestVersionJSON(t *testing.T) {
	rec := httptest.NewRecorder()
	versionHandler("example-service")(rec, httptest.NewRequest(http.MethodGet, "/version", nil))
	if rec.Code != http.StatusOK {
		t.Fatalf("status %d", rec.Code)
	}
	var got struct {
		Version string `json:"version"`
		Service string `json:"service"`
	}
	if err := json.Unmarshal(rec.Body.Bytes(), &got); err != nil {
		t.Fatal(err)
	}
	if got.Version == "" || got.Service != "example-service" {
		t.Fatalf("body %s: version and service must both be set", rec.Body.String())
	}
}
