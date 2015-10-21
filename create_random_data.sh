#!/bin/bash
outfile=random_data
size=$(( 1 * 10 **9 ))
echo Writing $size bytes to $outfile
openssl rand -out $outfile -base64 $size
