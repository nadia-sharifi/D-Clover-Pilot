#!/bin/bash
# Run script for Java assignments
# First runs unit tests with LeetCode-style output, then runs the Java file interactively

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# # Step 1: Run LeetCode-style test runner
# TEST_RUNNER="$SCRIPT_DIR/.clover-tests/leetcode-runner.sh"

# if [ -f "$TEST_RUNNER" ]; then
#     bash "$TEST_RUNNER"
#     echo ""
#     echo "=================================================="
#     echo ""
# else
#     echo "Warning: Test runner not found, skipping tests"
#     echo ""
# fi

# Step 2: Run the Java file interactively
# Determine which Java file to run
if [ -n "$2" ]; then
    # Use the file passed as second argument (after --test flag)
    JAVA_FILE="$2"
elif [ -n "$1" ] && [ "$1" != "--test" ] && [ "$1" != "-t" ]; then
    # Use the file passed as first argument
    JAVA_FILE="$1"
elif [ -n "$VSCODE_FILE" ]; then
    # Use VSCode environment variable if available
    JAVA_FILE="$VSCODE_FILE"
elif [ -n "$FILE" ]; then
    # Alternative environment variable
    JAVA_FILE="$FILE"
else
    # No argument provided - find the most recently modified .java file in the script directory
    JAVA_FILE=$(ls -t "$SCRIPT_DIR"/*.java 2>/dev/null | head -1)
    
    if [ -z "$JAVA_FILE" ]; then
        echo "Error: No Java files found in the current directory"
        exit 1
    fi
    
    echo "Running most recently modified Java file: $(basename "$JAVA_FILE")"
fi

# Validate the file has a .java extension
if [[ ! "$JAVA_FILE" =~ \.java$ ]]; then
    echo "Error: File must have a .java extension"
    exit 1
fi

# Validate the file exists
if [ ! -f "$JAVA_FILE" ]; then
    echo "Error: File '$JAVA_FILE' not found"
    exit 1
fi

# Extract the filename without path and extension
FILENAME=$(basename "$JAVA_FILE")
CLASSNAME="${FILENAME%.java}"

# Get the directory containing the Java file
FILE_DIR=$(dirname "$JAVA_FILE")

# Compile the Java file
echo "Compiling $FILENAME..."
javac "$JAVA_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    exit 1
fi

# Run the program
echo "Running program..."
echo "---"
java -cp "$FILE_DIR" "$CLASSNAME"
