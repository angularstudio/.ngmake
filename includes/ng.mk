PURPLE          := $(shell tput setaf 129)
GRAY            := $(shell tput setaf 245)
GREEN           := $(shell tput setaf 34)
BLUE            := $(shell tput setaf 25)
YELLOW          := $(shell tput setaf 3)
WHITE           := $(shell tput setaf 7)
RESET           := $(shell tput sgr0)

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


update:

	for

build:

	ng build --prod $(PROJECT)

build/all:

	@for F in $(PROJECTS); do ng build --prod $$F; done

publish:

	rm -rf dist/$(PROJECT)
	cd projects/$(PROJECT) && git commit -am'bump' || true
	cd projects/$(PROJECT) && npm version patch
	ng build --prod $(PROJECT) && cd dist/$(PROJECT) && npm publish --access=public

watch:

	rm -rf dist/$(PROJECT)
	nodemon -e ts -w projects/$(PROJECT)/src -x 'make build PROJECT=$(PROJECT) && ng serve'

## Update (and pull) everything to latest.
all/update: guard-BRANCH

	@git pull
	$(MAKE) git/update

### Commit and push all changes for all projects (make git/commit-and-push MESSAGE="my changes").
git/commit-and-push:

	@for F in $(PROJECTS); do echo "Committing $$F .." && cd $(PWD)/projects/$$F && git add . && git commit -am '$(MESSAGE)' && git push origin HEAD:master; done || true
	@git commit -am '$(MESSAGE)' || true
	@git push || true

### Pull (and/or checkout) branch across all projects.
git/pull: guard-BRANCH

	@git submodule update --init
	@for F in $(PROJECTS); do cd $(PWD)/services/$$F && git checkout $(BRANCH) && git pull; done

### Update (pull) all modules from git. (make git/update BRANCH=somename)
git/update: guard-BRANCH

	@git pull
	@git submodule update --init
	$(MAKE) git/pull
