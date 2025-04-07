#!/usr/bin/env bash
# run_tests.sh
#
# This script assumes:
# • The reference compiler is run as: ./cool --x86 file.cl
# • Your code generator is run as: ./main.exe file.cl-type
# • Both produce an assembly file named file.s in the working directory.
# • The test cases are organized so that for each test there is a base name
#   with a corresponding "base.cl" (for the reference) and "base.cl-type" (for main.exe).
#
# For each test case, the script:
#  1. Copies the source files to a temporary directory.
#  2. Runs the reference compiler on base.cl and renames its output to ref.s.
#  3. Runs your compiler on base.cl-type and renames its output to test.s.
#  4. Assembles both .s files with gcc.
#  5. Runs the executables and compares their outputs.

shopt -s nullglob

passed=0 

for test in *.cl-type; do
    # Get the base name (e.g., for "foo.cl-type", base is "foo")
    base="${test%.cl-type}"
    ref_source="${base}.cl"
    
    if [ ! -f "$ref_source" ]; then
        echo "Skipping ${base}: missing ${ref_source}"
        continue
    fi

    echo "=== Testing ${base} ==="

    # Create a temporary working directory for this test case
    tmpdir=$(mktemp -d)
    cp "$ref_source" "$tmpdir/"
    cp "$test" "$tmpdir/"
    
    pushd "$tmpdir" > /dev/null

    # Run the reference compiler on base.cl; it will generate file.s
    ./cool --x86 "${base}.cl --out ${base}Ref"|| { echo "Reference compiler failed for ${base}"; popd; rm -rf "$tmpdir"; continue; }
    mv "${base}Ref.s" ref.s

    # Run your code generator on base.cl-type; it will generate file.s
    ./main.exe "${base}.cl-type" || { echo "Your code generator failed for ${base}"; popd; rm -rf "$tmpdir"; continue; }
    mv "${base}.s" file.s

    # Assemble the generated assembly into executables
    gcc -o ref_exe ref.s || { echo "GCC failed for reference assembly of ${base}"; popd; rm -rf "$tmpdir"; continue; }
    gcc -o test_exe test.s || { echo "GCC failed for test assembly of ${base}"; popd; rm -rf "$tmpdir"; continue; }

    # Run the executables and capture their outputs (stdout and stderr)
    ./ref_exe > ref.out 2>&1
    ./test_exe > test.out 2>&1

    # Compare outputs
    if diff -q ref.out test.out > /dev/null; then
        echo "${base}: PASS"
        passed=passed+1
    else
        echo "${base}: FAIL"
        echo "Differences:"
        diff ref.out test.out
    fi
    
    popd > /dev/null
    rm -rf "$tmpdir"
done

echo "${passed}/23 testcases passed"

