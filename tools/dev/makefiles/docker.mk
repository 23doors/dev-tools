ifndef _include_docker_mk
_include_docker_mk := 1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)shared.mk

clean: clean-docker

.PHONY: clean-docker

clean-docker: ## Clean docker
	$(info $(_bullet) Cleaning <docker>)
	docker container prune -f
	docker image prune -f

endif