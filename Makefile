.PHONY: build test pack
build:
	mkdir -p bin
	go build -trimpath -o bin/template-worker ./cmd/template-worker

test:
	go test ./...

pack:
	bash scripts/pack.sh dist
