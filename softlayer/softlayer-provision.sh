#!/bin/bash
slcli -y vs create --datacenter=sjc01 --hostname=benchmaster --domain=benchmarks.ejw --billing=hourly --key=my_default_id_rsa --cpu=2 --memory=4096 --disk=100 --network=1000 --os=CENTOS_LATEST_64
sleep 5
slcli -y vs create --datacenter=sjc01 --hostname=benchslave1 --domain=benchmarks.ejw --billing=hourly --key=my_default_id_rsa --cpu=2 --memory=4096 --disk=100 --network=1000 --os=CENTOS_LATEST_64
sleep 5
slcli -y vs create --datacenter=sjc01 --hostname=benchslave2 --domain=benchmarks.ejw --billing=hourly --key=my_default_id_rsa --cpu=2 --memory=4096 --disk=100 --network=1000 --os=CENTOS_LATEST_64

# Wait for softlayer to issue ips to the servers we just created
echo "Waiting 300 seconds for hosts to provision and be issued ip addresses"
sleep 300

# Grab the ip addresses
masterip=`slcli vs list | grep benchmaster | awk '{print $3}'`
slave1ip=`slcli vs list | grep benchslave1 | awk '{print $3}'`
slave2ip=`slcli vs list | grep benchslave2 | awk '{print $3}'`

masterprivateip=`slcli vs list | grep benchmaster | awk '{print $4}'`
slave1privateip=`slcli vs list | grep benchslave1 | awk '{print $4}'`
slave2privateip=`slcli vs list | grep benchslave2 | awk '{print $4}'`

SlaveIps=($slave1ip $slave2ip)
SlavePrivateIps=($slave1ip $slave2ip)

# Generate ansible hosts file
hostsfile=sl.hosts
echo "[master]" > $hostsfile
echo "$masterip host_alias=benchmaster private_ip=$masterprivateip" >> $hostsfile
echo "[slaves]" >> $hostsfile
#for slaveip in "${SLAVES[@]}"
for i in $(seq 1 ${#SlaveIps[@]})
do
  echo "${SlaveIps[$i - 1]} host_alias=benchslave$i private_ip=${SlavePrivateIps[$i - 1]}"  >> $hostsfile
done

# Generate a script for logging in to the master
startfile=ssh-master.sh
echo "#!/usr/bin/bash" > $startfile
echo "ssh root@$masterip" >> $startfile # TODO, this should just kick off the start script
chmod 744 $startfile

# Generate hadoop links
hadoopfile=hadoop.html
echo "<html>" > $hadoopfile
echo "<a href='http://$masterip:50070/dfshealth.html'>DFS Health</a><br>" >> $hadoopfile
echo "<a href='http://$masterip:8088/cluster'>Cluster</a><br>" >> $hadoopfile
echo "<a href='http://$masterip:19888/jobhistory'>Job History</a><br>" >> $hadoopfile
echo "</html>" >> $hadoopfile

# Run Ansible Playbooks
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i sl.hosts ../benchmarktools-centos.yml
