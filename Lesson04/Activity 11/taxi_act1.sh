#!/usr/bin/env bash

# get a temp file name for the fares and the distances
temp_file_fares=temp${RANDOM}
temp_file_dists=temp${RANDOM}

# The 5th column of the file is the fare in decimal format
# Since the field has a two digits of precision, we can just remove the '.' to get the distance in units of cents
cut -d, -f5 "$1" | tr -d '.' >$temp_file_fares

# Extract the 4th column which has the distance in miles as decimal format
# Since the field has a two digits of precision, we can just remove the '.' to get the distance in units of 1/100 of a mile
cut -d, -f4 < "$1" | tr -d '.' >$temp_file_dists

# read each line of the fares file and total it, deal with leading 0s
IFS=' '
total_fare=0
while read fare
do
  (( total_fare += 10#${fare} ))
done <$temp_file_fares


# read each line of the distances file and total it, deal with leading 0
total_dist=0
while read dist
do
  (( total_dist += 10#${dist} ))
done <$temp_file_dists

echo -n "Average fare per mile is: " 
echo -n $(bc <<< "scale=2; $total_fare / $total_dist ") 
echo '$'

rm "$temp_file_fares"
rm "$temp_file_dists"

