package main

import "testing"

func TestAsInt64(t *testing.T) {
	n, ok := asInt64(float64(3))
	if !ok || n != 3 {
		t.Fatalf("got %v %v", n, ok)
	}
	if _, ok := asInt64("nope"); ok {
		t.Fatal("expected false")
	}
}
