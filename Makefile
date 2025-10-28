BRANDS := red green blue

#.PHONY: build
#build:
#	rm -rf dist && mkdir dist
#	npm run build-tokens
#	npm run build-scss

all: core tokens scss

core: clean-core
#	rm -rf brands/core/build
	./node_modules/.bin/paragon build-tokens --source ./paragon/tokens/src --build-dir ./paragon/build --themes none --verbose
#	./node_modules/.bin/paragon build-tokens --source ./brands/core/tokens --build-dir ./brands/core/build --themes none --verbose
#	cp -R brands/core/build/core build/core
	cp -R paragon/build/core build/core

clean-core:
	rm -rf paragon/build/core

tokens: clean-tokens tokens-red tokens-green tokens-blue

clean-tokens:
	rm -rf build/themes && mkdir -p build/themes

tokens-red:
	rm -rf brands/red/build
	./node_modules/.bin/paragon build-tokens --source ./brands/red/tokens --build-dir ./brands/red/build --exclude-core --themes light --verbose
	cp -R brands/red/build/themes/light build/themes/red

tokens-green:
	rm -rf brands/green/build
	./node_modules/.bin/paragon build-tokens --source ./brands/green/tokens --build-dir ./brands/green/build --exclude-core --themes light --verbose
	cp -R brands/green/build/themes/light build/themes/green

tokens-blue:
	rm -rf brands/blue/build
	./node_modules/.bin/paragon build-tokens --source ./brands/blue/tokens --build-dir ./brands/blue/build --exclude-core --themes light --verbose
	cp -R brands/blue/build/themes/light build/themes/blue

scss:
	rm -rf dist && mkdir -p dist
	./node_modules/.bin/paragon build-scss --corePath ./paragon/core.scss --themesPath ./build/themes --outDir ./dist

serve:
	./node_modules/.bin/paragon serve-theme-css --host 0.0.0.0

.PHONY: all core clean-core tokens clean-tokens tokens-red tokens-green tokens-blue scss serve
