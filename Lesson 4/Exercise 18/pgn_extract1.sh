#!/usr/bin/env bash

# A blank line is a line containing (only) 0 or more whitespaces
regex_blank="^[[:space:]]*$"

while read -r line
do
  # If the first argument is 1, print this line
  [[ $1 -eq 1 ]] && echo "$line"
  
  # Quit if line is blank
  [[ "$line" =~ $regex_blank ]] && break
done


