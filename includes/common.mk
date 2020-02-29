PURPLE          := $(shell tput setaf 129)
GRAY            := $(shell tput setaf 245)
GREEN           := $(shell tput setaf 34)
BLUE            := $(shell tput setaf 25)
YELLOW          := $(shell tput setaf 3)
WHITE           := $(shell tput setaf 7)
RESET           := $(shell tput sgr0)
export

.PHONY: help h
.DEFAULT_GOAL := help

header:

	@echo "${PURPLE}"
	@cat docs/banner.txt
	@echo "${RESET}"

help: header

		@echo Tools:
		@echo
		@awk '/^[a-zA-Z\/\-\_0-9]+:/ { \
				helpMessage = match(lastLine, /^## (.*)/); \
				if (helpMessage) { \
						helpCommand = substr($$1, 0, index($$1, ":")-1); \
						helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
						printf "  ${GREEN}%-10s${RESET} ${GRAY}%s${RESET}\n", helpCommand, helpMessage; \
				} \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
		@echo
		@echo Specific Targets:
		@echo
		@awk '/^[a-zA-Z\/\-\_0-9]+:/ { \
				helpMessage = match(lastLine, /^### (.*)/); \
				if (helpMessage) { \
						helpCommand = substr($$1, 0, index($$1, ":")-1); \
						helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
						printf "  ${GREEN}%-30s${RESET} ${GRAY}%s${RESET}\n", helpCommand, helpMessage; \
				} \
		} \
		{ lastLine = $$0 }' $(MAKEFILE_LIST)
		@echo

guard-%:
		@ if [ "${${*}}" = "" ]; then \
				echo "Environment variable $* not set (make $*=.. target or export $*=.."; \
				exit 1; \
		fi
