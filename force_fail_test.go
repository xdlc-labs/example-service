package main

import "testing"

func TestForceCIFail(t *testing.T) {
	t.Fatal("FORCE_CI_FAIL present — remove FORCE_CI_FAIL and this test")
}
