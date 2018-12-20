#!/usr/bin/env bash

# get a temp file name for the distances
temp_file_dists=temp${RANDOM}

# Extract the 4th column which has the distance in miles as decimal format
# Since the field has a two digits of precision, we can just remove the '.' to get the distance in units of 1/100 of a mile
# also include the duration that is in the last column
cut -d, -f4,6 "$1" | tr -d '.' >$temp_file_dists

# Maximum speed, line that contained it, and current line
max_speed=0
max_line_no=0
count=1

# read each line of the distances file split on comma
IFS=','
while read -a line
do
  duration=${line[1]}
  dist=${line[0]}
  # Multiply dist by 100 for precision (units become 1/100th of a mile)
  speed=$(( (10#${dist} * 100) / duration ))
  
  if (( speed > max_speed )) 
  then
    max_speed=$speed 
    max_line_no=$count
  fi
 
  (( count++ ))
   
done <$temp_file_dists

# Remember that max_speed has units of "1/10000 miles" per second, so the conversion to m/h is 3600/10000
echo -n "Highest speed of any trip: " 
echo -n $(bc <<< "scale=2; ${max_speed}*3600/10000") 
echo ' miles/hour'

echo "Line: " $max_line_no

rm "$temp_file_dists"

