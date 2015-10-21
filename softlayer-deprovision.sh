#!/bin/bash
# First remove the ips from our known hosts in case we get these again in the future
masterip=`slcli vs list | grep benchmaster | awk '{print $3}'`
slave1ip=`slcli vs list | grep benchslave1 | awk '{print $3}'`
slave2ip=`slcli vs list | grep benchslave2 | awk '{print $3}'`

ssh-keygen -f "/home/eric/.ssh/known_hosts" -R $masterid
ssh-keygen -f "/home/eric/.ssh/known_hosts" -R $slave1id
ssh-keygen -f "/home/eric/.ssh/known_hosts" -R $slave2id

# Then cancel the vms
masterid=`slcli vs list | grep benchmaster | awk '{print $1}'`
slave1id=`slcli vs list | grep benchslave1 | awk '{print $1}'`
slave2id=`slcli vs list | grep benchslave2 | awk '{print $1}'`

slcli -y vs cancel $masterid
slcli -y vs cancel $slave1id
slcli -y vs cancel $slave2id
