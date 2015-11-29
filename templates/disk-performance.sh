#!/bin/bash
df -h
echo "Which device do you want to profile?"
read device
echo "Profiling $device"
hdparm -Tt $device
