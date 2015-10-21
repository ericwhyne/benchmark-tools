#!/bin/bash
masterip="1.2.3.4"
slave1ip="5.6.7.8"
slave2ip="9.10.11.12"

SLAVES=($slave1ip $slave2ip)
ALLNODES=($masterip ${SLAVES[@]})

# Generate ansible hosts file
hostsfile=sl.hosts
echo "[master]" > $hostsfile
echo $masterip >> $hostsfile
echo "[slaves]" >> $hostsfile
for slaveip in "${SLAVES[@]}"
do
  echo "$slaveip" >> $hostsfile
done

# Generate an /etc/hosts file
etchostsfile=sl.etc.hosts
echo "$masterip benchmaster" > $etchostsfile
hostnum=1
for slaveip in "${SLAVES[@]}"
do
  echo "$slaveip benchslave$hostnum" >> $etchostsfile
  let hostnum+=1
done
# Send update to the /etc/hosts file
echo "cat $etchostsfile | ssh $user@$masterip"
for slaveip in "${SLAVES[@]}"
do
  echo "cat $etchostsfile | ssh $user@$slaveip"
done
echo "cat $etchostsfile | ssh $user@$slave1ip"
echo "cat $etchostsfile | ssh $user@$slave2ip"

for slaveip in "${ALLNODES[@]}"
do
  echo "host $slaveip"
done
