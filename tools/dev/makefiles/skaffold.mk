ifndef include_skaffold_mk
_include_skaffold_mk := 1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)shared.mk
include $(SELF_DIR)kubectl.mk

SKAFFOLD_VERSION ?= 1.20.0
SKAFFOLD := $(DEV_BIN_PATH)/skaffold_$(SKAFFOLD_VERSION)

KUBE_NAMESPACE ?= "default"
DOCKER_REPO ?= ""

$(SKAFFOLD):
	$(info $(_bullet) Installing <skaffold>")
	@mkdir -p $(DEV_BIN_PATH)
	curl -sSfL https://storage.googleapis.com/skaffold/releases/v$(SKAFFOLD_VERSION)/skaffold-$(OS)-amd64 -o $(SKAFFOLD)
	chmod u+x $(SKAFFOLD)

build: build-skaffold ## Build artifacts with Skaffold

debug: debug-skaffold ## Run in debugging mode with Skaffold

deploy: deploy-skaffold ## Deploy artifacts with Skaffold

dev: dev-skaffold ## Run in development mode with Skaffold

run: run-skaffold ## Run with Skaffold

.PHONY: clean-skaffold build-skaffold deploy-skaffold run-skaffold dev-skaffold debug-skaffold

clean-skaffold build-skaffold deploy-skaffold run-skaffold dev-skaffold debug-skaffold: $(SKAFFOLD) $(KUBECTL)

clean-skaffold: ## Clean Skaffold
	$(info $(_bullet) Cleaning <skaffold>)
	! kubectl config current-context &>/dev/null || \
	$(SKAFFOLD) delete --namespace $(KUBE_NAMESPACE)

build-skaffold:
	$(info $(_bullet) Building artifacts with <skaffold>)
	$(SKAFFOLD) build --namespace $(KUBE_NAMESPACE)

deploy-skaffold: build-skaffold
	$(info $(_bullet) Deploying with <skaffold>)
	$(SKAFFOLD) build -q --default-repo $(DOCKER_REPO) | $(SKAFFOLD) deploy --force --build-artifacts - --namespace $(KUBE_NAMESPACE)

run-skaffold:
	$(info $(_bullet) Running stack with <skaffold>)
	$(SKAFFOLD) run --force --namespace $(KUBE_NAMESPACE)

dev-skaffold:
	$(info $(_bullet) Running stack in development mode with <skaffold>)
	$(SKAFFOLD) dev --force --port-forward --namespace $(KUBE_NAMESPACE)

debug-skaffold:
	$(info $(_bullet) Running stack in debugging mode with <skaffold>)
	$(SKAFFOLD) debug --force --port-forward --namespace $(KUBE_NAMESPACE)

endif
