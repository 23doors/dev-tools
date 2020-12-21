ifndef _include_go_mk
_include_go_mk = 1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)shared.mk
include $(SELF_DIR)gobin.mk

GO ?= go
FORMAT_FILES ?= .

GOLANGCILINT_VERSION ?= 1.31.0
GOLANGCILINT := $(DEV_BIN_PATH)/golangci-lint_$(GOLANGCILINT_VERSION)
GOLANGCILINT_CONCURRENCY ?= 16

$(GOLANGCILINT): $(GOBIN)
	$(info $(_bullet) Installing <golangci-lint>)
	@mkdir -p $(DEV_BIN_PATH)
	GOBIN=bin $(GOBIN) github.com/golangci/golangci-lint/cmd/golangci-lint@v$(GOLANGCILINT_VERSION)

.PHONY: deps-go format-go lint-go test-go test-coverage-go integration-test-go

deps: deps-go ## Download dependencies

deps-go:
	$(info $(_bullet) Downloading dependencies <go>)
	$(GO) mod download

format: format-go ## Format code

format-go:
	$(info $(_bullet) Formatting code)
	$(GO) fmt -w $(FORMAT_FILES)

lint: lint-go ## Lint code

lint-go: $(GOLANGCILINT) ## Lint Go code
	$(info $(_bullet) Linting <go>)
	$(GOLANGCILINT) run --concurrency $(GOLANGCILINT_CONCURRENCY) ./...

test: test-go ## Run tests

test-go:
	$(info $(_bullet) Running tests <go>)
	$(GO) test ./...

test-coverage: test-coverage-go  ## Run tests with coverage

test-coverage-go:
	$(info $(_bullet) Running tests with coverage <go>)
	$(GO) test -cover ./...

integration-test: integration-test-go ## Run integration tests

integration-test-go:
	$(info $(_bullet) Running integration tests <go>)
	$(GO) test -tags integration -count 1 ./...

endif