#!/usr/bin/env bash

# A blank line is a line containing (only) 0 or more whitespaces
regex_blank="^[[:space:]]*$"

function read_chunk()
{
  while read -r line
  do
    # If the first argument is 1, print this line
    [[ $1 -eq 1 ]] && echo "$line"
  
    # Quit if line is blank
    [[ $line =~ $regex_blank ]] && return 0
  done

  # Quit with failure return code here since read could not get another line 
  return 1
}


function show_nth_game()
{
  local count=1
  local should_print=0

  # As long as count is less than or equal to N 
  while [[ $count -le $1 ]]
  do
    # Have we reached the Nth game, if so should_print is set 
    [[ $count -eq $1 ]] && should_print=1
    
    # Process the first set of lines in a game, and printing only if should_print is 1
    # Exit if the read_chunk returned non-zero
    read_chunk $should_print || break 
    
    # Repeat for the second chunk
    read_chunk $should_print
    
    # Increment the count and repeat the whole process
    count=$(( count + 1 ))
    
    # Quit after printing the game
    [[ $should_print -eq 1 ]] && break
  done
}


getopts 'm:n:' opt 

case $opt in
  m)
    echo Displaying games won in "$OPTARG" moves or less
  ;;
  
  n)
    echo Displaying Game "#$OPTARG"
    echo
    show_nth_game "$OPTARG"
  ;;
esac



