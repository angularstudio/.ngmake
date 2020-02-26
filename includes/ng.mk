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
