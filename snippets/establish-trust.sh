#!/bin/bash
host1=$1
host2=$2
user=root

keyfilename=`cat /dev/urandom | base64 | head -c 8`

# Set up the hosts to be able to communicate with each other
# host 1

ssh-keygen -t rsa -q -f temp-$keyfilename.key -N ''
ssh $user@$host1 "mkdir -p ~/.ssh"
cat temp-$keyfilename.key | ssh $user@$host1 "cat > ~/.ssh/id_rsa"
ssh $user@$host1 "chmod 600 ~/.ssh/id_rsa"
cat temp-$keyfilename.key.pub | ssh $user@$host1 "cat >> ~/.ssh/authorized_keys"
# host 2
ssh $user@$host2 "mkdir -p ~/.ssh"
cat temp-$keyfilename.key | ssh $user@$host2 "cat > ~/.ssh/id_rsa"
ssh $user@$host2 "chmod 600 ~/.ssh/id_rsa"
cat temp-$keyfilename.key.pub | ssh $user@$host2 "cat >> ~/.ssh/authorized_keys"

rm temp-$keyfilename.key
rm temp-$keyfilename.key.pub
