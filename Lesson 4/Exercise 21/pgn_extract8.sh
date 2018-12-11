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


# reads through the initial game data of PGN data 
# and sets the variable found to 1 if the specified regex matched any line
# Returns nonzero exit code if end of stream was encountered
function filter_game()
{
  # Initially assume not found
  found=0

  while read -r line
  do
    # Set found to 1 if the line matches the filter
    [[ $line =~ $1 ]] && found=1
    
    # If line is blank, we have reached end of game attributes, but not eos, so return 0
    [[ $line =~ $regex_blank ]] && return 0
  done
  
  # If it gets here there is no more data, so return nonzero
  return 1
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
# return value in $num_moves
function count_moves()
{
  num_moves=$(tr -d -c '.' <<< "$moves" | wc -c)
}


# Display the indexes of all games that have a win in fewer than the specified moves
function show_games_won_in()
{
  local index=1

  # While we have not reached the end of stream
  while filter_game '\[Result "(1-0)|(0-1)"\]' 
  do
    # Check if this game has a result
    if [[ $found -eq 1 ]]
    then
    
      # Read and count the moves
      read_moves
      count_moves
      
      # Display the game index if it has fewer than $1 moves
      [[ $num_moves -le $1 ]] && echo "Game $index: $num_moves moves" && echo "$moves"
      
    else # No result, skip over the moves list
    
      read_chunk 0
    fi
    
    # Increment the index
    index=$(( index + 1 ))  
  done
}

show_games_won_in "$1"

