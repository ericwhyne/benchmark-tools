source /home/hadoop/.bash_profile
#Format HDFS
hdfs namenode -format
## Start the cluster
start-dfs.sh
start-yarn.sh

# Check the status of HDFS:

hdfs dfsadmin -report

# Check YARN status:

yarn node -list
