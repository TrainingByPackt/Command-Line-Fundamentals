#!/usr/bin/env bash


# get a temp file name
temp_file=temp${RANDOM}

cut -d, -f5 "$1" | tr -d '.'  >$temp_file

# read each line of the CSV
total_fare=0
count=0
IFS=' '

while read fare
do

  total_fare=$(( 10#${fare} + total_fare ))  
  (( count++ ))
  
done <$temp_file

echo -n "Average fare is: " 
echo -n $(bc <<< "scale=2; ($total_fare / $count) / 100") 
echo '$'

rm "$temp_file"
