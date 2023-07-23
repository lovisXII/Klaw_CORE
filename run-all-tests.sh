#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NOC='\033[0m'

BASE_DIR=sw/tests/I/
BIN=obj_dir/Vcore

# Define a function to handle Ctrl+C
cleanup() {
    echo -e "${RED}Script interrupted by user.${NOC}"
    exit 1
}


# Function to process files
process_file() {
    local file="$1"
    # Extract the relative path to the file (relative to BASE_DIR)
    relative_path="${file#$BASE_DIR}"

    printf "Test ${relative_path} non opt..."
    timeout 20s "$BIN" "$file" >/dev/null 2>&1
    RES=$?
    if (( $RES == 0 ))
    then
        printf "${GREEN} passed\n${NOC}"
    elif (( $RES == 2 ))
    then
        printf "${YELLOW} exception\n${NOC}"
    else
        printf "${RED} failed\n${NOC}"
    fi

    printf "Test ${relative_path} opt..."
    timeout 20s "$BIN" "$file" -O >/dev/null 2>&1
    RES=$?

    if (( $RES == 0 ))
    then
        printf "${GREEN} passed\n${NOC}"
    elif (( $RES == 2 ))
    then
        printf "${YELLOW} exception\n${NOC}"
    else
        printf "${RED} failed\n${NOC}"
    fi
    # Set up the trap to capture Ctrl+C and call the cleanup function
    trap cleanup INT
}

make -j
tabs 45 55;

# Use 'find' to locate all files in subdirectories and pass them to the function
find "$BASE_DIR" -type f -name '*' -print0 | while IFS= read -r -d '' file; do
    process_file "$file"
done

tabs -0
