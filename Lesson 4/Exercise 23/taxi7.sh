#!/usr/bin/env bash


# get a temp file name
temp_file=temp${RANDOM}

# cut the 4th and 6th column - distance and duration, get rid of the decimal point
cut -d, -f4,6 "$1" | tr -d '.' >$temp_file

total_duration=0
total_distance=0
IFS=','

while read distance duration
do
  ((total_duration += 10#${duration}))
  ((total_distance += 10#${distance}))
  
done <$temp_file

miles=$(bc <<< "scale=2; $total_distance / 100")
hours=$(bc <<< "scale=2; $total_duration / 3600")

echo "$miles miles in $hours hours"
echo "Average speed is:" $(bc <<< "scale=2; $miles / $hours") "miles/hr"

# Get rid of the temp file
rm "$temp_file"
