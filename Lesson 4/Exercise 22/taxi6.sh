#!/usr/bin/env bash

# This function takes two timestamp arguments in 'YYYY-MM-DD HH:MM:SS' format 
# Prints the time difference between the two values in seconds
function trip_duration()
{
  # Get the timestamps from the line
  local line="$*"

  hh1=${line:11:2}
  mm1=${line:14:2}
  ss1=${line:17:2}

  hh2=${line:31:2}
  mm2=${line:34:2}
  ss2=${line:37:2}
  
  # Convert the HH MM SS to an absolute number of seconds
  n_start=$(( 10#${hh1} * 3600 + 10#${mm1} * 60 + 10#${ss1} ))
  n_stop=$(( 10#${hh2} * 3600 + 10#${mm2} * 60 + 10#${ss2} ))
  
  duration=$(( ((n_stop - n_start) + 86400) % 86400 ))
}


IFS=','

# read each line of the CSV
while read -r line
do
  # Split each line with a comma
  fields=( $line )
  
  # The first two fields are the two time stamps
  trip_duration "${fields[0]}" "${fields[1]}"
  
  if (( (duration > 120) && (duration < 10800) ))
  then
    echo "${line},${duration}"
  fi
 
done
