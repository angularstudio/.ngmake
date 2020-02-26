## Build a library (make build PROJECT=foolibrary)
build:

	ng build --prod $(PROJECT)

## Builds all libraries
build/all:

	@for F in $(PROJECTS); do ng build --prod $$F; done

## Publishes a library to npm (make publish PROJECT=foolibrary)
publish:

	rm -rf dist/$(PROJECT)
	cd projects/$(PROJECT) && git add . && git commit -am'bump' || true
	cd projects/$(PROJECT) && npm version patch
	ng build --prod $(PROJECT) && cd dist/$(PROJECT) && npm publish --access=public

## Builds + watches for changes for a library (make watch PROJECT=foolibrary)
watch:

	#rm -rf dist/$(PROJECT)
	nodemon -e ts,scss -d 1 -w projects/$(PROJECT)/src -x 'make build PROJECT=$(PROJECT) && ng serve'
