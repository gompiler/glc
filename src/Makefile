COMPILE_FLAGS = --pedantic --coverage

.PHONY: all
all: glc

.PHONY: clean
clean:
	stack clean --allow-different-user --full
	@rm -f glc.tix

.PHONY: cleangen
cleangen:
	@rm -f src/generated/TokenGen.hs
	@rm -f src/generated/ParserGen.hs

.PHONY: build
build: gen
	stack --allow-different-user build $(COMPILE_FLAGS)

.PHONY: gen
gen: src/generated/TokenGen.hs src/generated/ParserGen.hs

src/generated/TokenGen.hs: golite.x
	alex $< -g -o $@
	sed -i.bak 's/\\$$//;/./,/^$$/!d' $@ # Remove consecutive lines of whitespace
	@rm -f $@.bak

src/generated/ParserGen.hs: golite.y
	happy $< -agc -i -o $@
	sed -i.bak 's/\\$$//;/./,/^$$/!d' $@ # Remove consecutive lines of whitespace
	@rm -f $@.bak

glc: build
	@rm -f glc
	@rm -f glc.tix
	@ln -s .stack-work/*/*/*/*/bin/glc $@

# Continuous build, builds at every file modification, for development purposes only
.PHONY: cbuild
cbuild:
	stack build  --allow-different-user --file-watch $(COMPILE_FLAGS)

# Run hspec tests
.PHONY: test
test: gen
	stack test --allow-different-user $(COMPILE_FLAGS)

.PHONY: ctest
ctest: gen
	stack test --allow-different-user --coverage --file-watch $(COMPILE_FLAGS)

# Refactor code using hlint, hindent and stylish-haskell
.PHONY: refactor
refactor:
	@find . -name "*.hs" -not -path "./out/*" -not -path "./src/generated/*" -not -path "./.stack-work/*" -exec hlint --refactor --refactor-options="--inplace" {} \; -exec hindent {} \; -exec stylish-haskell -i {} \;
