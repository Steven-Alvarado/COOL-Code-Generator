# Makefile for COOL compiler testing

# Find all .cl files in the current directory
CL_FILES := $(wildcard *.cl)

# Generate target names for each .cl file
TYPE_TARGETS := $(CL_FILES:.cl=.cl-type)
TAC_TARGETS := $(CL_FILES:.cl=.cl-tac)
X86_TARGETS := $(CL_FILES:.cl=.s)

# Path to your custom code generator (adjust as needed)
CODE_GENERATOR := $(realpath ../main.exe)

# Default target: build all
all: type tac x86

# Target to run cool --type on all .cl files
type: $(TYPE_TARGETS)
	@echo "Generated all type files"

# Target to run cool --tac on all .cl files
tac: $(TAC_TARGETS)
	@echo "Generated all tac files"

# Target to run cool --x86 on all .cl-type files
x86: $(X86_TARGETS)
	@echo "Generated all x86 assembly files"

# Rule for generating .cl-type files
%.cl-type: %.cl
	@echo "Generating type file for $<"
	cool --type $<

# Rule for generating .cl-tac files
%.cl-tac: %.cl
	@echo "Generating TAC file for $<"
	cool --tac $< --out $*Ref

# Rule for generating .s files from .cl-type files
%.s: %.cl-type
	@echo "Generating x86 assembly for $<"
	cool --x86 $< --out $*Ref

# Target to run all three commands on a specific file
run-%: %.cl %.cl-type
	@echo "Running all commands on $*.cl"
	cool --type $*.cl
	cool --tac $*.cl --out $*Ref
	cool --x86 $*.cl-type --out $*Ref

# Test a single file with your compiler vs. reference compiler
test-%: %.cl %.cl-type
	@echo "=== Testing $* ==="
	@mkdir -p test-output
	@# Generate reference output
	cool --x86 $*.cl --out reference
	gcc --no-pie --static -o test-output/reference reference.s
	cd test-output && ./reference &> reference-output
	@# Generate your compiler output
	$(CODE_GENERATOR) $*.cl-type
	gcc --no-pie --static -o test-output/myoutput $*.s
	cd test-output && ./myoutput &> my-output
	@# Compare outputs
	@if diff -q test-output/reference-output test-output/my-output > /dev/null; then \
		echo "$*: PASS"; \
	else \
		echo "$*: FAIL"; \
		echo "Differences:"; \
		diff test-output/reference-output test-output/my-output; \
	fi

# Test all files
test-all:
	@echo "Testing all .cl files with your compiler vs. reference compiler"
	@PASSED=0; \
	TOTAL=0; \
	for file in $(CL_FILES); do \
		BASE=${file%.cl}; \
		make test-$BASE; \
		if [ $? -eq 0 ]; then \
			PASSED=$((PASSED+1)); \
		fi; \
		TOTAL=$((TOTAL+1)); \
	done; \
	echo "$PASSED/$TOTAL testcases passed"

# Run the full test script
test-script:
	@echo "Running test script..."
	@ORIGINAL_DIR=$(pwd); \
	passed=0; \
	TOTAL=0; \
	for test in *.cl-type; do \
		BASE=${test%.cl-type}; \
		REF_SOURCE="$BASE.cl"; \
		if [ ! -f "$REF_SOURCE" ]; then \
			echo "Skipping $BASE: missing $REF_SOURCE"; \
			continue; \
		fi; \
		echo "=== Testing $BASE ==="; \
		TOTAL=$((TOTAL+1)); \
		tmpdir=$(mktemp -d); \
		cp "$REF_SOURCE" "$tmpdir/"; \
		cp "$test" "$tmpdir/"; \
		cd "$tmpdir"; \
		cool --x86 "$BASE.cl" --out "${BASE}Ref" || { echo "Reference compiler failed for $BASE"; cd "$ORIGINAL_DIR"; rm -rf "$tmpdir"; continue; }; \
		mv "${BASE}Ref.s" ref.s; \
		"$ORIGINAL_DIR/$(CODE_GENERATOR)" "$BASE.cl-type" || { echo "Your code generator failed for $BASE"; cd "$ORIGINAL_DIR"; rm -rf "$tmpdir"; continue; }; \
		mv "$BASE.s" file.s; \
		gcc --no-pie --static -o ref_exe ref.s || { echo "GCC failed for reference assembly of $BASE"; cd "$ORIGINAL_DIR"; rm -rf "$tmpdir"; continue; }; \
		gcc --no-pie --static -o test_exe file.s || { echo "GCC failed for test assembly of $BASE"; cd "$ORIGINAL_DIR"; rm -rf "$tmpdir"; continue; }; \
		./ref_exe > ref.out 2>&1; \
		./test_exe > test.out 2>&1; \
		if diff -q ref.out test.out > /dev/null; then \
			echo "$BASE: PASS"; \
			passed=$((passed+1)); \
		else \
			echo "$BASE: FAIL"; \
			echo "Differences:"; \
			diff ref.out test.out; \
		fi; \
		cd "$ORIGINAL_DIR"; \
		rm -rf "$tmpdir"; \
	done; \
	echo "$passed/$TOTAL testcases passed"

# Clean target: remove all generated files except .cl files
clean:
	@echo "Cleaning all generated files..."
	find . -type f -not -name "*.cl" -not -name "Makefile" -not -name "*.sh" | xargs rm -f
	rm -rf test-output

# Clean specific file type targets
clean-type:
	rm -f *.cl-type *.cl-typeRef.cl-tac

clean-tac:
	rm -f *.cl-tac *.clRef.cl-tac

clean-x86:
	rm -f *.s *.clRef.s

clean-test:
	rm -rf test-output

# Help target
help:
	@echo "Available targets:"
	@echo "  all          : Build all targets (type, tac, x86)"
	@echo "  type         : Generate .cl-type files for all .cl files"
	@echo "  tac          : Generate .cl-tac files for all .cl files"
	@echo "  x86          : Generate .s files for all .cl-type files"
	@echo "  run-FILENAME : Run all commands on FILENAME.cl (e.g., make run-test)"
	@echo "  test-FILENAME: Test one file with your compiler vs reference (e.g., make test-test)"
	@echo "  test-all     : Test all .cl files with your compiler vs reference"
	@echo "  test-script  : Run the complete test script for all .cl-type files"
	@echo "  clean        : Remove all generated files except .cl files"
	@echo "  clean-type   : Remove only .cl-type files"
	@echo "  clean-tac    : Remove only .cl-tac files"
	@echo "  clean-x86    : Remove only .s files"
	@echo "  clean-test   : Remove only test output files"
	@echo "  help         : Show this help message"

.PHONY: all type tac x86 test-all test-script clean clean-type clean-tac clean-x86 clean-test helpan-x86 clean-test help86 test-all test-script clean clean-type clean-tac clean-x86 clean-test help
