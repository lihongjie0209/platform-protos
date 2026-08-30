SHELL := /bin/sh

TOOLS_DIR ?= $(CURDIR)/.tools/bin
BUF := $(TOOLS_DIR)/buf
PATH_WITH_TOOLS := $(TOOLS_DIR):$(PATH)
BUF_VERSION ?= v1.50.0
PROTOC_GEN_GO_VERSION ?= v1.36.12
PROTOC_GEN_GO_GRPC_VERSION ?= v1.5.1

.PHONY: bootstrap fmt fmt-check lint generate check test

bootstrap:
	@mkdir -p $(TOOLS_DIR)
	GOBIN=$(TOOLS_DIR) GOTOOLCHAIN=local go install github.com/bufbuild/buf/cmd/buf@$(BUF_VERSION)
	GOBIN=$(TOOLS_DIR) go install google.golang.org/protobuf/cmd/protoc-gen-go@$(PROTOC_GEN_GO_VERSION)
	GOBIN=$(TOOLS_DIR) go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@$(PROTOC_GEN_GO_GRPC_VERSION)

fmt:
	$(BUF) format -w

fmt-check:
	$(BUF) format --diff --exit-code

lint:
	$(BUF) lint

generate: fmt lint
	PATH="$(PATH_WITH_TOOLS)" $(BUF) generate

check: fmt-check lint
	@tmp_dir=$$(mktemp -d); \
	trap 'rm -rf "$$tmp_dir"' EXIT; \
	cp -R gen/go "$$tmp_dir/go"; \
	PATH="$(PATH_WITH_TOOLS)" $(BUF) generate; \
	diff -ru "$$tmp_dir/go" gen/go
	$(MAKE) test

test:
	go test ./...
	go vet ./...
