SELF_DIR    := $(dir $(lastword $(MAKEFILE_LIST)))

include $(SELF_DIR)/includes/common.mk
include $(SELF_DIR)/includes/git.mk
include $(SELF_DIR)/includes/ng.mk
