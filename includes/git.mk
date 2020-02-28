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
	@for F in $(PROJECTS); do cd $(PWD)/projects/$$F && git checkout $(BRANCH) && git pull; done

### Update (pull) all modules from git. (make git/update BRANCH=somename)
git/update: guard-BRANCH

	@git pull
	@git submodule update --init
	$(MAKE) git/pull
