#!/bin/bash
# Update /etc/hosts
hostnum=1
for var in "$@"
do
    if [ "$var" -eq "$1" ]
    then
      echo "$var benchmaster"
    else
      echo "$var benchslave$hostnum"
      let hostnum+=1
    fi
done
