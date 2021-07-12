DEV_MAKEFILES ?= tools/dev/makefiles

include $(DEV_MAKEFILES)/changelog.mk
include $(DEV_MAKEFILES)/docker.mk
include $(DEV_MAKEFILES)/git.mk
include $(DEV_MAKEFILES)/go-sqlc.mk
include $(DEV_MAKEFILES)/go.mk
include $(DEV_MAKEFILES)/gobin.mk
include $(DEV_MAKEFILES)/kind.mk
include $(DEV_MAKEFILES)/kubectl.mk
include $(DEV_MAKEFILES)/openapi.mk
include $(DEV_MAKEFILES)/skaffold.mk
