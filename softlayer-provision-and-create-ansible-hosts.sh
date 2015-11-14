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

# cloud image specific configuration
user=root

# Generate ansible hosts file ##################################################
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

ansible -i sl.hosts all -u root -m ping

# Generate an /etc/hosts file ##################################################
#moved to ansible
#etchostsfile=etc.hosts
#echo "$masterip benchmaster" > $etchostsfile
#hostnum=1
#for slaveip in "${SLAVES[@]}"
#do
#  echo "$slaveip benchslave$hostnum" >> $etchostsfile
#  let hostnum+=1
#done

# Send update to the /etc/hosts file
#for nodeip in "${ALLNODES[@]}"
#do
#  cat $etchostsfile | ssh $user@$nodeip "cat >> /etc/hosts"
#done

# Set up the hosts to be able to communicate with each other ###################
# Note: this has been moved to the ansible playbook
#keyfilename=`cat /dev/urandom | base64 | head -c 8`
#ssh-keygen -t rsa -q -f temp-$keyfilename.key -N ''
#for nodeip in "${ALLNODES[@]}"
#do
#  ssh $user@$nodeip "mkdir -p ~/.ssh"
#  cat temp-$keyfilename.key | ssh $user@$nodeip "cat > ~/.ssh/id_rsa"
#  ssh $user@$nodeip "chmod 600 ~/.ssh/id_rsa"
#  cat temp-$keyfilename.key.pub | ssh $user@$nodeip "cat >> ~/.ssh/authorized_keys"
#done
#rm temp-$keyfilename.key
#rm temp-$keyfilename.key.pub
