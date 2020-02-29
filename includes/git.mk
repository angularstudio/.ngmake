## Update (and pull) everything to latest.
update: guard-BRANCH

	cd .ngmake && git checkout master && git pull

	@git pull
	@git submodule update --init
	@for F in $(PROJECTS); do cd $(PWD)/projects/$$F && git checkout $(BRANCH) && git pull; done

### Commit and push all changes for all projects (make git/commit-and-push MESSAGE="my changes").
git/commit-and-push: guard-MESSAGE

	@git add --all
	@for F in $(PROJECTS); do echo "Committing $$F .." && cd $(PWD)/projects/$$F && git add . && git commit -am '$(MESSAGE)' && git push origin HEAD:master; done || true
	@git commit -am '$(MESSAGE)' || true
	@git push || true

