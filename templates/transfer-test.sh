#!/bin/bash
fromhost=$1
tohost=$2
user=root
bytes=`bc <<< '2^10'`

# Generate random data on server 1
echo Generating random data
ssh $user@$fromhost "openssl rand -out ~/random.data $bytes"
echo Transferring random data
# note: time writes it's output to stderr, that's why we need to catch it and cat it
seconds=`/usr/bin/time -f "%e" scp $user@$fromhost:~/random.data $user@$tohost:~/ |& cat`
echo Transfer of $bytes bytes took $seconds seconds.
