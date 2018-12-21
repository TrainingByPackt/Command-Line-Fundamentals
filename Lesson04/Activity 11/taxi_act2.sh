#!/usr/bin/env bash

# read each line of the CSV file
# Line has data like:
# 2017-01-09 11:13:28,2017-01-09 11:25:45,1,3.30,15.3,737
# using space and comma as IFS will get us the start and stop times at column index 2 and 4

IFS=', '
count=0

# We dont need the 1st and 3rd column, but we need to specify a variable anyway, so we call it dummy1 and dummy2
while read dummy1 start dummy2 stop
do
  # Since the format is HH:MM:SS for both the time values we can use string compares 
  # we will compare against 6AM and 10AM 
  [[ $start > '06:00:00' && $stop < '10:00:00' ]] && (( count++ ))
done 

echo "Number of trips that started after 6AM and ended before 10AM is $count"
