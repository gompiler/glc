.PHONY: all
all: glcT

# local build
.PHONY: allL
allL: glc

.PHONY: clean
clean:
	stack clean --allow-different-user --full

.PHONY: cleangen
cleangen:
	@rm -f src/generated/Tokens.hs
	@rm -f src/generated/Parser.hs

.PHONY: build
build: src/generated/Tokens.hs #src/generated/Parser.hs
	stack --allow-different-user build

src/generated/Tokens.hs: golite.x
	alex $< -g -o $@

src/generated/Parser.hs: golite.y
	happy $< -agc -o $@

glc: build
	@rm -f glc
	@ln -s .stack-work/*/*/*/*/bin/glc $@

# Continuous build, builds at every file modification, for development purposes only
.PHONY: cbuild
cbuild:
	stack build  --allow-different-user --file-watch

# ------------------------------------------------------------
# |                   Trottier specific                      |
# ------------------------------------------------------------
# Export variables required to run on cs-x machines in Trottier
.PHONY: exT
exT: PATH := /usr/local/pkgs/haskell/stack-1.9.3-linux-x86_64:$(PATH)
exT: export STACK_ROOT := /mnt/local

.PHONY: glcT
glcT: exT glc

.PHONY: cleanT
cleantrot: exT clean

.PHONY: cbuildT
cbuildT: exT cbuild
