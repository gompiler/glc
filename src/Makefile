COMPILE_FLAGS = --pedantic --coverage
JLIBS = Utils GlcSlice GlcIntSlice GlcArray GlcIntArray
JFILES = $(addsuffix .j,$(addprefix glcutils/,$(JLIBS)))
JAVAFILES = $(addsuffix .java,$(addprefix ../glcgutils/src/main/java/glcutils/,$(JLIBS)))

.PHONY: all
all: glc

.PHONY: clean
clean:
	stack clean --allow-different-user --full
	mvn clean -f ../glcgutils
	@rm -f glc.tix

.PHONY: cleangen
cleangen:
	@rm -f src/generated/TokenGen.hs
	@rm -f src/generated/ParserGen.hs

.PHONY: build
build: gen jutils
	stack --allow-different-user build $(COMPILE_FLAGS)

.PHONY: gen
gen: src/generated/TokenGen.hs src/generated/ParserGen.hs

.PHONY: report
report: stack --allow-different-user hpc report glc.tix

.PHONY: jutils
jutils: $(JFILES)

../glcgutils/target/glcutils-1.0-SNAPSHOT.jar: ../glcgutils/pom.xml $(JAVAFILES)
	mvn install -f ../glcgutils

.PHONY: disassemble
disassemble: ../glcgutils/target/glcutils-1.0-SNAPSHOT.jar
	python3 ../Krakatau/disassemble.py ../glcgutils/target/glcutils-1.0-SNAPSHOT.jar
$(JFILES): disassemble

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
test: gen jutils
	@rm -f glc.tix
	stack test --allow-different-user $(COMPILE_FLAGS)

.PHONY: ctest
ctest: gen jutils
	@rm -f glc.tix
	stack test --allow-different-user --file-watch $(COMPILE_FLAGS)

# Refactor code using hlint, hindent and stylish-haskell
.PHONY: refactor
refactor:
	@find . -name "*.hs" -not -path "./out/*" -not -path "./src/generated/*" -not -path "./.stack-work/*" -exec hlint --refactor --refactor-options="--inplace" {} \; -exec hindent {} \; -exec stylish-haskell -i {} \;
