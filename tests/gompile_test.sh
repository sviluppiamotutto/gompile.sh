#!/bin/bash

# This script is used to test the gompile script

# Set the path to the gompile script
GOMPILE_SCRIPT_PATH="$PWD/../gompile.sh"

# Set the path to tests directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# Set the path to testapp directory
TESTAPP_PATH="$SCRIPT_DIR/testapp"

# Set the path to output binaries
OUTPUT_BINARIES_PATH="$SCRIPT_DIR/bin"

# Set a counter for tests passed
TESTS_PASSED=0
# Set a counter for tests failed
TESTS_FAILED=0

# move_to_testapp_directory() moves to testapp directory
move_to_testapp_directory() {
    cd "$TESTAPP_PATH" || exit 1
}

# exit_from_testapp_directory() exits from testapp directory
exit_from_testapp_directory() {
    cd "$SCRIPT_DIR" || exit 1
}

# clean_output_binaries() cleans output binaries
clean_output_binaries() {
    rm -rf "$OUTPUT_BINARIES_PATH"
}

# Get system platform.
SYSTEM_PLATFORM=$(go env GOOS)
# Get system architecture.
SYSTEM_ARCH=$(go env GOARCH)

# run_test() runs a test passed as argument and increments TESTS_FAILED if test fails
run_test() {
    echo
    echo "Running test: $1"
    echo "----------------------------------------"
    $1
    if [ $? -ne 0 ]; then
        echo "Test failed: $1"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo "Test passed: $1"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi
    echo "----------------------------------------"
    echo
}

# show_test_results() shows test results
show_test_results() {
    echo "Tests passed: $TESTS_PASSED"
    echo "Tests failed: $TESTS_FAILED"
}

# it_compiles_for_system_architecture() tests if gompile.sh compiles for system architecture
it_compiles_for_system_architecture() {

    # Clean output binaries
    clean_output_binaries

    # Move to testapp directory
    move_to_testapp_directory

    (exec $GOMPILE_SCRIPT_PATH -path "$TESTAPP_PATH" -output "$OUTPUT_BINARIES_PATH")
    if [ $? -ne 0 ]; then
        echo "gompile.sh failed to compile for system architecture."
        return 1
    elif [ ! -f "$OUTPUT_BINARIES_PATH/testapp_${SYSTEM_PLATFORM}_${SYSTEM_ARCH}" ]; then
        echo "gompile.sh no output binary for system architecture."
        return 1
    fi

    # Exit from testapp directory
    exit_from_testapp_directory
}

# it_compiles_for_specified_platform_and_architecture() tests if gompile.sh compiles for specified platform and architecture
it_compiles_for_specified_platform_and_architecture() {

    # Clean output binaries
    clean_output_binaries

    # Move to testapp directory
    move_to_testapp_directory

    (exec $GOMPILE_SCRIPT_PATH -path "$TESTAPP_PATH" -output "$OUTPUT_BINARIES_PATH" -platform "$SYSTEM_PLATFORM" -arch "$SYSTEM_ARCH")
    if [ $? -ne 0 ]; then
        echo "gompile.sh failed to compile for system architecture."
        return 1
    elif [ ! -f "$OUTPUT_BINARIES_PATH/testapp_${SYSTEM_PLATFORM}_${SYSTEM_ARCH}" ]; then
        echo "gompile.sh no output binary for system architecture."
        return 1
    fi

    # Exit from testapp directory
    exit_from_testapp_directory
}

# it_compiles_with_archive() tests if gompile.sh compiles with archive
it_compiles_with_archive() {

    # Clean output binaries
    clean_output_binaries

    # Move to testapp directory
    move_to_testapp_directory

    (exec $GOMPILE_SCRIPT_PATH -path "$TESTAPP_PATH" -output "$OUTPUT_BINARIES_PATH" -archive)
    if [ $? -ne 0 ]; then
        echo "gompile.sh failed to compile for system architecture."
        return 1
    elif [ ! -f "$OUTPUT_BINARIES_PATH/testapp_${SYSTEM_PLATFORM}_${SYSTEM_ARCH}.tar.gz" ]; then
        echo "gompile.sh no output binary for system architecture."
        return 1
    fi

    # Exit from testapp directory
    exit_from_testapp_directory
}

echo

run_test it_compiles_for_system_architecture
run_test it_compiles_for_specified_platform_and_architecture
run_test it_compiles_with_archive

echo

if [ $TESTS_FAILED -ne 0 ]; then
    show_test_results
    exit 1
fi

show_test_results
exit 0
