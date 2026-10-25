#!/usr/bin/env bash

# Synopsis:
# Run the test runner on a solution.

# Arguments:
# $1: exercise slug
# $2: path to solution folder
# $3: path to output directory

# Output:
# Writes the test results to a results.json file in the passed-in output directory.
# The test results are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/test-runners/interface.md

# Example:
# ./bin/run.sh two-fer path/to/solution/folder/ path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug path/to/solution/folder/ path/to/output/directory/"
    exit 1
fi

slug="$1"
solution_dir=$(realpath "$2")
output_dir=$(realpath "$3")
results_file="${output_dir}/results.json"

# Cap on the output included in the message of an error results.json
: "${MAX_MESSAGE_BYTES:=65536}"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${slug}: testing..."

# Remove any stale results so a crash can't leave old results behind
rm -f "${results_file}"

# Run the tests for the provided implementation file and redirect stdout and
# stderr to capture it. Read stdin from /dev/null so that after an uncaught
# error jconsole exits instead of waiting for input.
test_output=$(/opt/j9.5/bin/jconsole bin/run.ijs "${slug}" "${solution_dir}/" "${output_dir}/" 2>&1 </dev/null)
exit_code=$?

# If J crashed or exited before writing valid results, report an error,
# keeping the (capped) output followed by the exit code
if ! jq -e . "${results_file}" >/dev/null 2>&1; then
    message="jconsole exited with code ${exit_code} without producing results."
    if [ -n "${test_output}" ]; then
        if (( ${#test_output} > MAX_MESSAGE_BYTES )); then
            test_output=$(printf "%s\n%s" "${test_output:0:MAX_MESSAGE_BYTES}" "[output truncated]")
        fi
        message=$(printf "%s\n%s" "${test_output}" "${message}")
    fi
    jq -n --arg message "${message}" '{version: 3, status: "error", message: $message}' > "${results_file}"
fi

result=$(jq . "${results_file}")
printf '%s\n' "${result}" > "${results_file}"

echo "${slug}: done"
