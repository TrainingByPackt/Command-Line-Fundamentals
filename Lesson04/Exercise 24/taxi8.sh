#!/usr/bin/env bash

# read each line of the CSV
total_fare=0
count=0
IFS=','

while read -a line
do
  fare=${line[4]}
  total_fare=$(bc <<< "scale=2; $fare + $total_fare")  
  (( count++ ))
  
done

echo -n "Average fare is: " 
echo -n $(bc <<< "scale=2; $total_fare / $count") 
echo '$'
