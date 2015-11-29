#!/bin/bash
# m1.medium has two cores and 3.75gb of memory
instancetype=m1.medium
# Ami ami-8997afe0 is Centos 6.5 in US-East zone
imageid=ami-8997afe0
# add your own key name here
keyname=benchmark-tools

echo "Provisioning instances..."
aws ec2 run-instances \
  --image-id $imageid \
  --key-name $keyname \
  --instance-type $instancetype \
  --associate-public-ip-address \
  --instance-initiated-shutdown-behavior terminate \
  --count 3 > provision-data.json


# create tags
echo "Tagging instances..."
masterid=`./aws-ids master`
slaveids=`./aws-ids slaves`
aws ec2 create-tags --resources $masterid --tags Key=Name,Value=benchmaster
aws ec2 create-tags --resources $slaveids --tags Key=Name,Value=benchslave

# Wait for awsto issue ips to the servers we just created
echo "Waiting 300 seconds to be assigned public ip addresses..."
sleep 300
aws ec2 describe-instances --instance-ids `./aws-ids all` > instance-descriptions.json

echo "IP addresses:"
./aws-ips all

#TODO: make sure this works!!!
# Generate ansible hosts file
hostsfile=aws.hosts
masterip=`./aws-ips master`
SLAVES=(`./aws-ips slaves`)
echo "[master]" > $hostsfile
echo "$masterip host_alias=benchmaster" >> $hostsfile
hostnum=1
echo "[slaves]" >> $hostsfile
for slaveip in "${SLAVES[@]}"
do
  echo "$slaveip host_alias=benchslave$hostnum"  >> $hostsfile
  let hostnum+=1
done
