#!/usr/bin/env bash

# Calculates the higest taxi fare per minute


# get a temp file name for the fares
temp_file_fares=temp${RANDOM}

# The 5th column of the file is the fare in decimal format with 2 digits of precision
# Extract it and remove the '.' character, to get the fare in cents
# Also include the 6th column that is the trip duration in seconds
cut -d, -f5,6 "$1" | tr -d '.' >$temp_file_fares


# read each line of the temp file
# format has FF,ZZ
# where FF is the price values in cents and ZZ is the duration
IFS=','

# this will hold the known maximum fare per unit time
max=0

# this will hold the line number of that max data
line_no=0

# Current line
count=1

while read fare duration
do
  # Since we use integer divide, for precision, we scale up the fare by 100 and scale it down at the end
  cost=$(( (100 * 10#${fare} ) / 10#${duration} ))  
  (( cost > max )) && max=$cost line_no=$count
  (( ++count ))
done <$temp_file_fares

# Remember that max has units of 1/100 cents per second, so the conversion factor to $/minute is 60/10000
echo -n "Highest fare per minute is: " 
echo -n $(bc <<< "scale=2; $max*60/10000") 
echo '$'
echo "Line: " $line_no

rm "$temp_file_fares"

