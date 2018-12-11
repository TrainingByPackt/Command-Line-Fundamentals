#!/usr/bin/env bash

# A blank line is a line containing (only) 0 or more whitespaces
regex_blank="^[[:space:]]*$"

function read_chunk()
{
  while read -r line
  do
    # If the first argument is 1 , print this line
    [[ $1 -eq 1 ]] && echo "$line"
  
    # Quit if line is blank
    [[ $line =~ $regex_blank ]] && return 0
  done

  # Quit with failure return code here since read could not get another line 
  return 1
}


# reads through the initial game data of PGN data and returns 
# success if any line matched the regex in the first argument
function filter_game()
{
  # ret will be returned by the function - initially assume failure
  local ret=1

  while read -r line
  do
    # Set ret to 0 if the line matches the filter
    [[ $line =~ $1 ]] && ret=0
    
    # FOR TESTING: Print the line
    [[ $line =~ $1 ]] && echo "$line"

  
    # Break if line is blank
    [[ $line =~ $regex_blank ]] && break
  done
  
  return $ret
}


for i in {1..30}
do
  filter_game '\[Result "(1-0)|(0-1)"\]'
  read_chunk 0
done

