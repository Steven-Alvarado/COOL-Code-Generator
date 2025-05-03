#!/usr/bin/env bash
# test_compiler.sh - Script to test your compiler against the reference compiler

# Don't exit on errors - we want to run all tests
set +e

# Enable nullglob for handling empty directories
shopt -s nullglob

# Path to your compiler - change this to the correct path
CODE_GENERATOR="../main.exe"

# If CODE_GENERATOR is not absolute, convert it to absolute path
if [[ ! "$CODE_GENERATOR" = /* ]]; then
    CODE_GENERATOR="$(pwd)/$CODE_GENERATOR"
fi

# Check if the code generator exists
if [ ! -f "$CODE_GENERATOR" ]; then
    echo "Error: Compiler not found at $CODE_GENERATOR"
    echo "Please update the CODE_GENERATOR variable in this script."
    exit 1
fi

# Make sure the compiler is executable
chmod +x "$CODE_GENERATOR" 2>/dev/null || true

# Initialize counter
passed=0
total=0
failed=0
skipped=0

# Arrays to store test case names
passed_tests=()
failed_tests=()
skipped_tests=()

# Process each .cl-type file
for test in *.cl-type; do
    # Get the base name (e.g., for "foo.cl-type", base is "foo")
    base="${test%.cl-type}"
    ref_source="${base}.cl"
    
    # Skip if the reference source doesn't exist
    if [ ! -f "$ref_source" ]; then
        echo "Skipping ${base}: missing ${ref_source}"
        skipped=$((skipped+1))
        skipped_tests+=("$base")
        continue
    fi
    
    echo "=== Testing ${base} ==="
    total=$((total+1))
    
    # Create a temporary working directory for this test case
    tmpdir=$(mktemp -d)
    cp "$ref_source" "$tmpdir/"
    cp "$test" "$tmpdir/"
    
    # Change to the temporary directory
    pushd "$tmpdir" > /dev/null
    
    # Run the reference compiler on base.cl-type
    if ! cool --x86 "${base}.cl-type" --out "${base}Ref" 2>/dev/null; then
        echo "Reference compiler failed for ${base}"
        failed=$((failed+1))
        failed_tests+=("$base (reference compiler failed)")
        popd > /dev/null
        rm -rf "$tmpdir"
        continue
    fi
    mv "${base}Ref.s" ref.s
    
    # Run your code generator on base.cl-type
    if ! "$CODE_GENERATOR" "${base}.cl-type" 2>/dev/null; then
        echo "Your code generator failed for ${base}"
        failed=$((failed+1))
        failed_tests+=("$base (your compiler failed)")
        popd > /dev/null
        rm -rf "$tmpdir"
        continue
    fi
    mv "${base}.s" file.s 2>/dev/null || {
        echo "Output file not found";
        failed=$((failed+1));
        failed_tests+=("$base (output file not found)");
        popd > /dev/null;
        rm -rf "$tmpdir";
        continue;
    }
    
    # Assemble the generated assembly into executables
    if ! gcc --no-pie --static -o ref_exe ref.s 2>/dev/null; then
        echo "GCC failed for reference assembly of ${base}"
        failed=$((failed+1))
        failed_tests+=("$base (gcc failed on reference output)")
        popd > /dev/null
        rm -rf "$tmpdir"
        continue
    fi
    
    if ! gcc --no-pie --static -o test_exe file.s 2>/dev/null; then
        echo "GCC failed for test assembly of ${base}"
        failed=$((failed+1))
        failed_tests+=("$base (gcc failed on your output)")
        popd > /dev/null
        rm -rf "$tmpdir"
        continue
    fi
    
    # Run the executables and capture their outputs
    timeout 5s ./ref_exe > ref.out 2>&1 || {
        echo "Warning: Reference executable timed out or crashed for ${base}";
        failed=$((failed+1));
        failed_tests+=("$base (reference executable crashed)");
        popd > /dev/null;
        rm -rf "$tmpdir";
        continue;
    }
    
    timeout 5s ./test_exe > test.out 2>&1 || {
        echo "Warning: Test executable timed out or crashed for ${base}";
        failed=$((failed+1));
        failed_tests+=("$base (your executable crashed)");
        popd > /dev/null;
        rm -rf "$tmpdir";
        continue;
    }
    
    # Compare outputs
    if diff -q ref.out test.out > /dev/null; then
        echo "${base}: PASS"
        passed=$((passed+1))
        passed_tests+=("$base")
    else
        echo "${base}: FAIL"
        echo "Differences:"
        diff ref.out test.out
        failed=$((failed+1))
        failed_tests+=("$base (outputs differ)")
    fi
    
    # Return to the original directory and clean up
    popd > /dev/null
    rm -rf "$tmpdir"
done

# Print summary
echo "========================================="
echo "SUMMARY:"
echo "${passed}/${total} testcases passed"
echo "${failed}/${total} testcases failed"
if [ "$skipped" -gt 0 ]; then
    echo "${skipped} testcases skipped"
fi
echo "========================================="

# Print passed tests
if [ ${#passed_tests[@]} -gt 0 ]; then
    echo "PASSED TESTS:"
    for test in "${passed_tests[@]}"; do
        echo "  - $test"
    done
fi

# Print failed tests
if [ ${#failed_tests[@]} -gt 0 ]; then
    echo "FAILED TESTS:"
    for test in "${failed_tests[@]}"; do
        echo "  - $test"
    done
fi

# Print skipped tests
if [ ${#skipped_tests[@]} -gt 0 ]; then
    echo "SKIPPED TESTS:"
    for test in "${skipped_tests[@]}"; do
        echo "  - $test"
    done
fi

# Return appropriate exit code
if [ "$passed" -eq "$total" ]; then
    exit 0
else
    exit 1
fi
