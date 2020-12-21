ifndef _include_openapi_mk
_include_openapi_mk := 1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)/shared.mk

OPENAPI_SPEC ?= api/api.yaml
OPENAPI_OUTPUT ?= pkg/api
OPENAPI_PACKAGE_NAME ?= api

OPENAPIGENERATORCLI := $(SELF_DIR)scripts/openapi-generator-cli
OPENAPIGENERATORCLI_VERSION ?= 4.3.1

lint: lint-openapi ## Lint code

generate: generate-openapi ## Generate code

.PHONY: lint-openapi generate-openapi

lint-openapi generate-openapi: export OPENAPIGENERATORCLI_VERSION := $(OPENAPIGENERATORCLI_VERSION)

lint-openapi: ## List OpenAPI spec
	$(info $(_bullet) Linting <openapi>)
	$(OPENAPIGENERATORCLI) validate --input-spec $(OPENAPI_SPEC)

generate-openapi: ## Generate OpenAPI code
	$(info $(_bullet) Generating <openapi>)
	$(OPENAPIGENERATORCLI) generate \
		--input-spec $(OPENAPI_SPEC) \
		--output $(OPENAPI_OUTPUT) \
		--generator-name go-experimental \
		--package-name=$(OPENAPI_PACKAGE_NAME) \
		--additional-properties withGoCodegenComment \
		--import-mappings=uuid.UUID=github.com/google/uuid --type-mappings=UUID=uuid.UUID

endif