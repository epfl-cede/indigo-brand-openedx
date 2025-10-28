BRANDS := red green blue

all: scss dist dist/theme-urls.json
.PHONY: all

tokens-core:
	rm -rf paragon/build
	./node_modules/.bin/paragon build-tokens --source ./paragon/tokens/src --build-dir ./paragon/build --themes none --verbose
.PHONY: tokens-core

scss-core: tokens-core
	rm -rf paragon/dist && mkdir -p paragon/dist
	./node_modules/.bin/paragon build-scss --corePath ./paragon/core.scss --themesPath ./paragon/build/themes --outDir ./paragon/dist
.PHONY: scss-core

define rule_template

tokens-$(1):
	rm -rf brands/$(1)/build
	./node_modules/.bin/paragon build-tokens --source ./brands/$(1)/tokens --build-dir ./brands/$(1)/build --exclude-core --themes light --verbose
	mv brands/$(1)/build/themes/light brands/$(1)/build/themes/$(1)
.PHONY: tokens-$(1)

# somehow, --excludeCore is slower than without
scss-$(1): tokens-$(1)
	rm -rf brands/$(1)/dist && mkdir -p brands/$(1)/dist
	./node_modules/.bin/paragon build-scss --corePath ./paragon/core.scss --themesPath ./brands/$(1)/build/themes --outDir ./brands/$(1)/dist
.PHONY: dist-$(1)

endef

$(foreach brand,$(BRANDS),$(eval $(call rule_template,$(brand))))

scss:
	make -j16 scss-core $(patsubst %,scss-%,$(BRANDS))
.PHONY: scss

dist:
	rm -rf dist && mkdir -p dist
	cp paragon/dist/core.* dist/
	for brand in $(BRANDS); do cp brands/$$brand/dist/$$brand.* dist/; done
.PHONY: dist

# When adding a new brand, `brands/theme-urls.json` has to be updated manually for it to work with `make serve`.
dist/theme-urls.json: brands/theme-urls.json
	cp $< $@

serve:
	./node_modules/.bin/paragon serve-theme-css --host 0.0.0.0
.PHONY: serve
