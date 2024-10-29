#!/bin/bash

PATH="$PATH:$(pwd)"

################################################################################

# This function checks whether .quicktest exists or not
quicktest_not_exist() {
    script="$1"
    if ! [ -d ".quicktest" ]; then
        echo "$script: quicktest directory .quicktest not found" >&2
        exit 1
    fi
}


# This function checks the elementary errors of pathnames passed as arguments
# The order of priority is:
# 1. check if file or directory exists
# 2. check if file is non-readable
# 3. check if the file is a directory
valid_file_check() {
    file="$1"
    script="$2"

    # check if file/directory exists
    if ! [ -e "$file" ]; then
        echo "$script: $file: No such file or directory" >&2
        exit 1
    fi
    # check if file is non-readable
    if ! [ -r "$file" ]; then
        echo "$script: $file: Permission denied" >&2
        exit 1
    fi
    # check if file is a directory
    if [ -d "$file" ]; then
        echo "$script: $file: Is a directory" >&2
        exit 1
    fi
}

# This function is responsible for checking the validity
# of the contents in <autotests> or _AUTOTESTS
# The order of priority is:
# 1. valid line
# 2. valid label
# 3. valid arguments
# 4. valid options
# 5. valid stdin
# 6. duplicated labels
autotests_error_checks() {
    autotests="$1"
    edit_autotests="$2"
    line_num=1
    label_list=""

    while read -r line; do
        # if empty line or a comment then continue to next iteration
        if echo "$line" | grep -E '^#' >/dev/null || [ -z "$line" ]; then
            line_num=$((line_num+1))
            continue
        fi
        # check the three '|' per line case
        if ! echo "$line" | grep -E '^[^|]*\|[^|]*\|[^|]*\|[^|]*$' >/dev/null; then
            echo "quicktest-add: ${autotests}:${line_num}: invalid line: ${line}" >&2
            exit 1   
        fi
        # check valid label
        label="$(echo "$line" | cut -d '|' -f1,1)"
        if ! echo "$label" | grep -E '^[a-z]+[a-zA-Z0-9_]*$' >/dev/null; then
            echo "quicktest-add: ${autotests}:${line_num}: invalid test label: ${label}" >&2
            exit 1
        fi
        # check valid args
        arguments="$(echo "$line" | cut -d '|' -f2,2)"        
        if ! echo "$arguments" | grep -E '^[ a-zA-Z0-9_.-]*$' >/dev/null; then
            echo "quicktest-add: ${autotests}:${line_num}: invalid test arguments: ${arguments}" >&2
            exit 1
        fi   
        # check valid options
        options="$(echo "$line" | cut -d '|' -f4,4)"
        if [ -n "$options" ] && echo "$options" | grep -E '[^b^c^d^w]' >/dev/null; then
            echo "quicktest-add: ${autotests}:${line_num}: invalid test options: ${options}" >&2
            exit 1
        fi
        # check valid stdin
        stdin="$(echo "$line" | cut -d '|' -f3,3)"
        if printf '%s' "$stdin" | grep -E '\\[^n]' >/dev/null; then
            echo -n "quicktest-add: ${autotests}:${line_num}: invalid test stdin: " >&2
            printf '%s' "$stdin" >&2
            echo >&2
            exit 1
        fi
        # check duplicate labels
        if echo "$label_list" | grep -E "$label" >/dev/null; then
            echo "quicktest-add: ${autotests}:${line_num}: repeated test label: ${label}" >&2
            exit 1
        fi
        # add seen labels and increment line number
        label_list="$label_list $label"
        line_num=$((line_num+1))
    done < "$edit_autotests"
}

# This function is responsible for checking the validity
# of the contents in <automarking> or _AUTOMARKING
# The order of priority is:
# 1. valid line
# 2. valid label
# 3. valid arguments
# 4. valid options
# 5. valid marks
# 6. valid stdin
# 7. duplicated labels
automarking_error_checks() {
    automarking="$1"
    edit_automarking="$2"
    line_num=1
    label_list=""
    while read -r line; do
        # if empty line or a comment then continue to next iteration
        if echo "$line" | grep -E '^#' >/dev/null || [ -z "$line" ]; then
            line_num=$((line_num+1))
            continue
        fi
        # check the three '|' per line case
        if ! echo "$line" | grep -E '^[^|]*\|[^|]*\|[^|]*\|[^|]*\|[^|]*$' >/dev/null; then
            echo "quicktest-add: ${automarking}:${line_num}: invalid line: ${line}" >&2
            exit 1   
        fi
        # check valid label
        label="$(echo "$line" | cut -d '|' -f1,1)"
        if ! echo "$label" | grep -E '^[a-z]+[a-zA-Z0-9_]*$' >/dev/null; then
            echo "quicktest-add: ${automarking}:${line_num}: invalid test label: ${label}" >&2
            exit 1
        fi
        # check valid args
        arguments="$(echo "$line" | cut -d '|' -f2,2)"
        if ! echo "$arguments"|grep -E '^[ a-zA-Z0-9_.-]*$' >/dev/null; then
            echo "quicktest-add: ${automarking}:${line_num}: invalid test arguments: ${arguments}" >&2
            exit 1
        fi
        # check valid options
        options="$(echo "$line" | cut -d '|' -f4,4)"
        if [ -n "$options" ] && echo "$options"|grep -E '[^b^c^d^w]' >/dev/null; then
            echo "quicktest-add: ${automarking}:${line_num}: invalid test options: ${options}" >&2
            exit 1
        fi
        # check valid test marks
        marks="$(echo "$line" | cut -d '|' -f5,5)"
        if [ -z "$marks" ] || ! echo "$marks"|grep -E '^[0-9]*$' >/dev/null; then
            echo "quicktest-add: ${automarking}:${line_num}: invalid test marks: ${marks}" >&2
            exit 1
        fi
        # check valid stdin
        stdin="$(echo "$line" | cut -d '|' -f3,3)"
        if printf '%s' "$stdin" | grep -E '\\[^n]' >/dev/null; then
            echo -n "quicktest-add: ${automarking}:${line_num}: invalid test stdin: " >&2
            printf '%s' "$stdin" >&2
            echo >&2
            exit 1
        fi
        # check duplicate labels in _automarking
        if echo "$label_list" | grep -E "$label" >/dev/null; then
            echo "quicktest-add: ${automarking}:${line_num}: repeated test label: ${label}" >&2
            exit 1
        fi
        label_list="$label_list $label"
        line_num=$((line_num+1))
    done < "$edit_automarking"
}

compare_outputs() {
    exp_output="$1"
    act_output="$2"
    diff_options="$3"
    option_digit="$4"
    label="$5"
    file_descriptor="$6"
    stdout_diff="$7"

    # temp files to handle option d
    exp_output_digit="$(mktemp)"
    act_output_digit="$(mktemp)"

    # temp files to handle difference in a single newline
    exp_output_newline="$(mktemp)"
    act_output_newline="$(mktemp)"

    # if we have d, then we want to only consider digits and '\n'
    if [ "$option_digit" -eq 1 ]; then
        sed 's/[^0-9]*//g' < "$exp_output" > "$exp_output_digit"
        sed 's/[^0-9]*//g' < "$act_output" > "$act_output_digit"
    fi
    
    exp_bytes="$(wc -c < "$exp_output")"
    act_bytes="$(wc -c < "$act_output")"

    output_diff=1
    # noticed that diff -B was order sensitive so had exhaust the cases
    # this case handles if option d was triggered and outputs were the same
    if [ "$option_digit" -eq 1 ] && \
        diff $diff_options "$exp_output_digit" "$act_output_digit" >/dev/null || \
        [ "$option_digit" -eq 1 ] && \
        diff $diff_options "$act_output_digit" "$exp_output_digit" >/dev/null; then
        output_diff=0
    
    # this case handles if option d was not triggered and outputs were the same
    elif diff $diff_options "$exp_output" "$act_output" >/dev/null || \
        diff $diff_options "$act_output" "$exp_output" >/dev/null; then
        output_diff=0

    # otherwise, the outputs are different
    else
        # since we compare stdout first, we can print failed
        if [ "$file_descriptor" = "stdout" ]; then
            echo "* Test $label failed."
        
        # if stdout was the same, but stderr was different then we print failed
        elif [ "$stdout_diff" -eq 0 ]; then
            echo "* Test $label failed."
        fi
        cp "$act_output" "$act_output_newline"
        echo >> "$act_output_newline"   
        cp "$exp_output" "$exp_output_newline"
        echo >> "$exp_output_newline"

        if diff "$act_output_newline" "$exp_output" >/dev/null; then
            echo "Missing newline at end of $file_descriptor"

        elif diff "$exp_output_newline" "$act_output" >/dev/null; then
            echo "Extra newline at end of $file_descriptor"       

        elif [ "$exp_bytes" -eq 0 ] && [ "$act_bytes" -ne 0 ]; then
            echo "--- No $file_descriptor expected, these $act_bytes bytes produced:"
            cat "$act_output"
            echo

        elif [ "$act_bytes" -eq 0 ] && [ "$exp_bytes" -ne 0 ]; then
            echo "--- No $file_descriptor produced, these $exp_bytes bytes expected:"
            cat "$exp_output"        
            echo

        else
            echo "--- Incorrect $file_descriptor of $act_bytes bytes:"
            cat "$act_output"
            echo

            echo "--- Correct $file_descriptor is these $exp_bytes bytes:"
            cat "$exp_output"
            echo
        fi
    fi

    rm -f "$exp_output_newline" "$act_output_newline" 
    rm -f "$exp_output_digit" "$act_output_digit" 

    return "$output_diff"
}