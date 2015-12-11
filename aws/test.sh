hostsfile=aws.hosts
masterip=`./aws-ips master`
SlaveIps=(`./aws-ips slaves`)
masterprivateip=`./aws-private-ips master`
SlavePrivateIps=(`./aws-private-ips slaves`)
echo "[master]" > $hostsfile
echo "$masterip host_alias=benchmaster private_ip=$masterprivateip" >> $hostsfile
echo "[slaves]" >> $hostsfile
#for slaveip in "${SLAVES[@]}"
for i in $(seq 1 ${#SlaveIps[@]})
do
  echo "${SlaveIps[$i - 1]} host_alias=benchslave$i private_ip=${SlavePrivateIps[$i - 1]}"  >> $hostsfile
done
