#!/usr/bin/env bash

# A blank line is a line containing (only) 0 or more whitespaces
regex_blank="^[[:space:]]*$"


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


# Read all the lines of the PGN move list and concatenate them into the variable moves
function read_moves()
{ 
  # Clear the moves variable
  moves=''

  while read -r line
  do
    # Quit if line is blank
    [[ $line =~ $regex_blank ]] && return 0
    
    # Append the line to moves with space in between
    moves="${moves} ${line}"
   
  done

  # Quit with failure return code here since read could not get another line 
  return 1
}


# counts the number of moves in the moves list of a PGN format game
# Assumes that "moves" is a string containing the complete moves list 
function count_moves()
{
  num_moves=$(tr -d -c '.' <<< "$moves" | wc -c)
}


for i in {1..3}
do
  filter_game '\[Result "(1-0)|(0-1)"\]'
  read_moves
  echo "$moves"
  
  count_moves
  echo "$num_moves" moves in game 
  echo
done
