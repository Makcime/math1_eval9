#!/bin/bash

# Get the highest existing question number
max_q_num=$(ls src/questions/q*.tex 2>/dev/null | sed 's/src\/questions\/q//;s/\.tex//' | sort -n | tail -1)

# If there are no existing questions, set the starting number to 0
if [[ -z "$max_q_num" ]]; then
    max_q_num=0
fi

# Increment the number
next_q_num=$((max_q_num + 1))

# Create the new files
cp  "src/questions/qx.tex" "src/questions/q${next_q_num}.tex"
# Feedback to the user
echo "Created src/uestions/q${next_q_num}.tex"

