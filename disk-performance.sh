#!/bin/bash
host=$1
user=root

ssh $user@$host df -h

echo "Which device do you want to profile?"
read device
echo "Profiling $device"
ssh $user@$host hdparm -Tt $device
