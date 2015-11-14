#!/bin/bash
cd /usr/local/hadoop/share/hadoop/mapreduce
hadoop jar $(ls hadoop-mapreduce-examples-2*.jar) terasort /terasort/in /terasort/out
