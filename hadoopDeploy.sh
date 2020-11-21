#!/bin/bash
#this program will not only install a hadoop cluster on the machines that you tell it to, but also format the hdfs, and start the cluster
send () { #installs hadoop on a target machine, the process is the same for every node, of every type.
	hosts=$5 #The difference between nodes is specified in the configuration script, which are set semi-dynamically
	theList=$4
	hostAndName=$3
	user=$(echo $3 | grep -o ".*@" | tr -d '@')
	echo $hostAndName
	echo $1 $2
	scp runNameNode.sh hadoopInstaller.sh $theList $hosts uninstall.sh $hostAndName:/home/$user/
	ssh $hostAndName neofetch
	ssh $hostAndName pi 50
	ssh -t $hostAndName ./hadoopInstaller.sh $1 $2 $theList $hosts
	echo "----------------------"
}


#will start a datanode and nodemanager on each host
startHost () {
	host=$1
	ssh $host "/usr/local/hadoop/bin/yarn nodemanager &"
	ssh $host "/usr/local/hadoop/bin/hdfs datanode &"
}


export -f send
export -f startHost

#examples of the format for all the needed files can be found in the same folder as this program
nameNode=$1 #user name and address of the namenode
jobTracker=$2 #user name and address of the jobTracker, right now, it needs to be the same as the nameNode.
theList=$3 #the file name of the list contain all the machines to be used as data/client nodes
hosts=$4 #the file name of the list of hosts that need to be added to all the machines' /etc/hosts file

mapfile -t clients < $theList
for host in "${clients[@]}"; do
	send $nameNode $jobTracker $host $theList $hosts
done

. /home/$(whoami)/.bashrc
hdfs namenode -format
start-all.sh
echo "waiting for cluster to exit safe mode before seeding file system"
sleep 5
hdfs dfs -ls /
hdfs dfs -mkdir /test
hdfs dfs -ls /
cd testcode
hdfs dfs -put students.txt /test/
hdfs dfs -ls /test
hdfs dfs -cat /test/students.txt
