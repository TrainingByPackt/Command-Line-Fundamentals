#!/usr/bin/env bash

# This function takes two timestamp arguments in 'YYYY-MM-DD HH:MM:SS' format 
# Prints the time difference between the two values in seconds
function trip_duration()
{
  # Split the dates and times into an array, using space as the IFS
  IFS=' '
  local dt_start=( $1 )
  local dt_stop=( $2 )
  
  # dt_start[1] and dt_stop contain the time value as HH:MM:SS
  # Split the times into HH, MM and SS, using colon as the IFS
  IFS=':'
  local t_start=( ${dt_start[1]} )
  local t_stop=( ${dt_stop[1]} )
  
  # Convert the HH MM SS to an absolute number of seconds
  local n_start=$(( 10#${t_start[0]} * 3600 + 10#${t_start[1]} * 60 + 10#${t_start[2]} ))
  local n_stop=$(( 10#${t_stop[0]} * 3600 + 10#${t_stop[1]} * 60 + 10#${t_stop[2]} ))
  
  echo $(( ((n_stop - n_start) + 86400) % 86400 ))
}


# read each line of the CSV
while read -r line
do
  # Split each line with a comma
  IFS=','
  fields=( $line )
  
  # The first two fields are the two time stamps
  trip_duration "${fields[0]}" "${fields[1]}" 
done

