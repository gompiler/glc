COMPILE_FLAGS = --pedantic --coverage
JSRCDIR = ../glcgutils/src/main/java/glcutils/
JAVAFILES = $(wildcard $(JSRCDIR)*.java)
JLIBS = $(basename $(notdir $(JAVAFILES)))
JFILES = $(addsuffix .j,$(addprefix glcutils/,$(JLIBS)))

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
	@rm -rf glcutils
	mvn clean -f ../glcgutils

.PHONY: build
build: gen ../Krakatau/assemble.py
	stack --allow-different-user build $(COMPILE_FLAGS)

../Krakatau/assemble.py:
	git submodule update --init --recursive

.PHONY: gen
gen: src/generated/TokenGen.hs src/generated/ParserGen.hs $(JFILES)

.PHONY: report
report:
	stack --allow-different-user hpc report glc.tix

$(JFILES): glcutils

glcutils: ../glcgutils/pom.xml $(JAVAFILES)
	@rm -rf glcutils
	mvn install -f ../glcgutils
	python3 ../Krakatau/disassemble.py ../glcgutils/target/glcutils-1.0-SNAPSHOT.jar

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
	@rm -f glc.tix
	stack test --allow-different-user $(COMPILE_FLAGS)

.PHONY: ctest
ctest: gen
	@rm -f glc.tix
	stack test --allow-different-user --file-watch $(COMPILE_FLAGS)

# Refactor code using hlint, hindent and stylish-haskell
.PHONY: refactor
refactor:
	@find . -name "*.hs" -not -path "./out/*" -not -path "./src/generated/*" -not -path "./.stack-work/*" -exec hlint --refactor --refactor-options="--inplace" {} \; -exec hindent {} \; -exec stylish-haskell -i {} \;
