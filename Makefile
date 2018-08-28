PACKAGES=$(shell go list ./... | grep -v '^github.com/rynmrtn/go-skel/vendor/')
PROJ_NAME=go-skel
BIN_DIR=bin

all: clean build

build: $(BIN_DIR)/$(PROJ_NAME)

clean:
	rm -rf $(BIN_DIR)

bin/$(PROJ_NAME):
	mkdir -p $(BIN_DIR)
	CGO_ENABLED=0 go build -x -o $(BIN_DIR)/$(PROJ_NAME) -ldflags "\
        -extldflags '-static' \
		-s -w \
        -X $(PACKAGE_NAME)/version.BuildTime=$(shell date -u +%FT%T%z)\
        -X $(PACKAGE_NAME)/version.GitCommit=$(shell git rev-parse --short HEAD)\
        -X $(PACKAGE_NAME)/version.Version=$(shell git describe --abbrev=0 --tags 2> /dev/null || echo v0.0.1)"

go-lint:
	$(eval GOLINT_INSTALLED := $(shell which gometalinter))

	@if [ "$(GOLINT_INSTALLED)" = "" ] ; then \
		go get -u github.com/alecthomas/gometalinter; \
		gometalinter --install --force; \
	fi;

lint: go-lint
	gometalinter \
        --disable-all \
        --enable=gofmt \
        --enable=goimports \
        --enable=golint \
        --enable=misspell \
        --exclude=gen.go \
        --vendor \
        ./...

test:
	go test -v -race $(PACKAGES)

.PHONY: build clean lint test
