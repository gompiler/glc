COMPILE_FLAGS = --pedantic

.PHONY: all
all: glc

.PHONY: clean
clean:
	stack clean --allow-different-user --full

.PHONY: cleangen
cleangen:
	@rm -f src/generated/Tokens.hs
	@rm -f src/generated/Parser.hs

.PHONY: build
build: gen
	stack --allow-different-user build $(COMPILE_FLAGS)

.PHONY: gen
gen: src/generated/Tokens.hs src/generated/Parser.hs

src/generated/Tokens.hs: golite.x
	alex $< -g -o $@
	sed -i 's/\\$$//;/./,/^$$/!d' $@ # Remove consecutive lines of whitespace

src/generated/Parser.hs: golite.y
	happy $< -agc -i -o $@
	sed -i 's/\\$$//;/./,/^$$/!d' $@ # Remove consecutive lines of whitespace

glc: build
	@rm -f glc
	@ln -s .stack-work/*/*/*/*/bin/glc $@

# Continuous build, builds at every file modification, for development purposes only
.PHONY: cbuild
cbuild:
	stack build  --allow-different-user --file-watch $(COMPILE_FLAGS)

# Run hspec tests
.PHONY: test
test: gen
	stack test --allow-different-user --coverage $(COMPILE_FLAGS)

.PHONY: ctest
ctest: gen
	stack test --allow-different-user --coverage --file-watch $(COMPILE_FLAGS)

# Refactor code using hlint, hindent and stylish-haskell
.PHONY: refactor
refactor:
	@find . -name "*.hs" -not -path "./out/*" -not -path "./src/generated/*" -not -path "./.stack-work/*" -exec hlint --refactor --refactor-options="--inplace" {} \; -exec hindent {} \; -exec stylish-haskell -i {} \;
