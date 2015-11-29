#!/bin/bash
slcli -y vs create --datacenter=sjc01 --hostname=benchmaster --domain=benchmarks.ejw --billing=hourly --key=my_default_id_rsa --cpu=2 --memory=4096 --disk=100 --network=1000 --os=CENTOS_LATEST_64
sleep 5
slcli -y vs create --datacenter=sjc01 --hostname=benchslave1 --domain=benchmarks.ejw --billing=hourly --key=my_default_id_rsa --cpu=2 --memory=4096 --disk=100 --network=1000 --os=CENTOS_LATEST_64
sleep 5
slcli -y vs create --datacenter=sjc01 --hostname=benchslave2 --domain=benchmarks.ejw --billing=hourly --key=my_default_id_rsa --cpu=2 --memory=4096 --disk=100 --network=1000 --os=CENTOS_LATEST_64

# Wait for softlayer to issue ips to the servers we just created
sleep 300

# Grab the ip addresses
masterip=`slcli vs list | grep benchmaster | awk '{print $3}'`
slave1ip=`slcli vs list | grep benchslave1 | awk '{print $3}'`
slave2ip=`slcli vs list | grep benchslave2 | awk '{print $3}'`

SLAVES=($slave1ip $slave2ip)
ALLNODES=($masterip ${SLAVES[@]})

# Generate ansible hosts file
hostsfile=sl.hosts
echo "[master]" > $hostsfile
echo "$masterip host_alias=benchmaster" >> $hostsfile
hostnum=1
echo "[slaves]" >> $hostsfile
for slaveip in "${SLAVES[@]}"
do
  echo "$slaveip host_alias=benchslave$hostnum"  >> $hostsfile
  let hostnum+=1
done

# Generate a script for starting the benchmarks
startfile=startbenchmark.sh
echo "#!/usr/bin/bash" > $startfile
echo "ssh root@$masterip" >> $startfile # TODO, this should just kick off the start script

ansible -i sl.hosts all -u root -m ping
