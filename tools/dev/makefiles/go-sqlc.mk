ifndef include_sqlc_mk
_include_sqlc_mk := 1

SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)shared.mk

SQLC := $(DEV_BIN_PATH)/sqlc_$(SQLC_VERSION)
SQLC_VERSION ?= 1.8.0

$(SQLC):
	$(info $(_bullet) Installing <sqlc>)
	@mkdir -p $(DEV_BIN_PATH)
	curl -sSfL https://github.com/kyleconroy/sqlc/releases/download/v$(SQLC_VERSION)/sqlc-v$(SQLC_VERSION)-$(OS)-$(ARCH).tar.gz | tar -C $(DEV_BIN_PATH) -xz sqlc
	mv $(DEV_BIN_PATH)/sqlc $(SQLC)
	chmod u+x $(SQLC)

.PHONY: generate generate-sqlc

generate: generate-sqlc ## Generate code

generate-sqlc: $(SQLC) ## Generate SQLC code
	$(info $(_bullet) Generating <sqlc>)
	$(SQLC) generate

endif
