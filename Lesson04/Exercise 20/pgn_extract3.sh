#!/usr/bin/env bash

getopts 'm:n:' opt || exit

case $opt in
  m)
    echo Displaying games won in "$OPTARG" moves or less
  ;;
  
  n)
    echo Displaying game "#$OPTARG"
  ;;
  
esac


