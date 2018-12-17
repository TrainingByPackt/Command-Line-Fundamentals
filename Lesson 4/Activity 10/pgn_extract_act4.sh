#!/usr/bin/env bash

# Reads a set of lines and a blank line
# prints them if first argument is 1
function read_chunk()
{
  while read -r line
  do
    # If the first argument is 1, print this line
    (( $1 == 1 )) && echo "$line"
  
    # Quit if line is blank
    [[ -z $line ]] && return 0
  done

  # Quit with failure return code here since read could not get another line 
  return 1
}


function show_nth_game()
{
  local count=1
  local should_print=0

  # As long as count is less than or equal to N 
  while (( count <= $1 ))
  do
    # Have we reached the Nth game, if so should_print is set 
    (( count == $1 )) && should_print=1
    
    # Process the first set of lines in a game, and printing only if should_print is 1
    # Exit if the read_chunk returned non-zero
    read_chunk $should_print || return 
    
    # Repeat for the second chunk
    read_chunk $should_print
    
    # Increment the count and repeat the whole process
    (( count ++ ))
    
    # Quit after printing the game
    (( should_print == 1 )) && break
  done
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
    [[ -z $line ]] && return 0
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
    [[ -z $line ]] && return 0
    
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
  # split moves into an array with the '.' as delimiter
  IFS='.'
  local moves_arr=( $moves )
  
  # The second last entry contains the last moves index 
  # Use the negative array index feature of bash to get it
  local second_last=${moves_arr[@]: -2 : 1}
  
  # Now Second last contains something like "Kg1 Qg3+ 31" and the last word is the count
  IFS=' '
  local second_last_arr=( $second_last )
  
  # Again use negative array index to get the number into moves_count
  num_moves=${second_last_arr[@]: -1 : 1}
}


# Display the indexes of all games that have a win in fewer than the specified moves
function show_games_won_in()
{
  local index=1

  # While we have not reached the end of stream
  while filter_game '\[Result "(1-0|0-1)"\]' 
  do
    # Check if this game has a result
    if (( found == 1 ))
    then
    
      # Read and count the moves
      read_moves
      count_moves
      
      # Display the game index and moves if it has fewer than $1 moves
      (( num_moves <= $1 )) && echo "Game $index: $num_moves moves" && echo "$moves" && echo 
      
    else # No result, skip over the moves list
    
      read_chunk 0
    fi
    
    # Increment the index
    (( index++ ))
  done
}


function usage()
{
  echo PGN Game extractor tool
  echo -----------------------
  echo "Usage:"
  echo "    $0 -n N"
  echo "        Displays the Nth game in the file"
  echo
  echo "    $0 -m M"
  echo "        Displays the games that were won in fewer than M moves"
  echo 
}
   

getopts 'm:n:' opt 

case $opt in
  m)
    echo Displaying games won in "$OPTARG" moves or less
    echo
    show_games_won_in "$OPTARG"
  ;;
  
  n)
    echo Displaying Game "#$OPTARG"
    echo
    show_nth_game "$OPTARG"
  ;;
  
  *)
    usage
    
esac
