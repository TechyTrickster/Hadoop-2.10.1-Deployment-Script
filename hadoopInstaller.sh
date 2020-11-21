#!/bin/bash
HADOOP_HOME=/usr/local/hadoop
HADOOP_APP=/app/hadoop/tmp
hEnv=$HADOOP_HOME/etc/hadoop/hadoop-env.sh
HADOOP_CORE=$HADOOP_HOME/etc/hadoop/core-site.xml
HADOOP_HDFS=$HADOOP_HOME/etc/hadoop/hdfs-site.xml
HADOOP_MAPR=$HADOOP_HOME/etc/hadoop/mapred-site.xml
HADOOP_YARN=$HADOOP_HOME/etc/hadoop/yarn-site.xml
HADOOP_SLAV=$HADOOP_HOME/etc/hadoop/slaves

#arguments
nameNode=$(echo $1 | grep -o "@.*" | tr -d '@')
jobTracker=$(echo $2 | grep -o "@.*" | tr -d '@')
clientList=$3
hosts=$4

#testing right now, don't need to keep redownloading the tar
echo "basics"
sudo apt install openjdk-8-jdk openssh-server
sudo service ssh restart #make sure that the service actually starts!
wget https://mirrors.koehn.com/apache/hadoop/common/hadoop-2.10.1/hadoop-2.10.1.tar.gz
tar -xzf hadoop-2.10.1.tar.gz
rm hadoop-2.10.1.tar.gz
sudo mv hadoop-2.10.1 $HADOOP_HOME
sudo chown –R $(whoami):$(whoami) $HADOOP_HOME
JAVA_HOME=$(readlink -f $(whereis java | sed 's/java:\ //g' | tr ' ' '\n' | head -n1) | sed 's/\/bin\/java//g')
userBashRC="/home/$(whoami)/.bashrc"
sudo cp /etc/hosts /etc/skel/ #backup the hosts file to /etc/skel


#configures the users .bashrc
echo "configurinng .bashrc"
sudo echo "export JAVA_HOME=$JAVA_HOME" >> $userBashRC
sudo echo "export HADOOP_HOME=$HADOOP_HOME" >> $userBashRC
sudo echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> $userBashRC
#. $userBashRC

#configures the hadoop-env.sh file
echo "configuring hadoop-env.sh"
sudo cat $hEnv | sed "s,export JAVA_HOME.*,export JAVA_HOME=$JAVA_HOME,g" > $hEnv.n
sudo mv $hEnv.n $hEnv
sudo echo 'export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true' >> $hEnv
sudo mkdir -p $HADOOP_APP
sudo chown -R $(whoami):$(whoami) $HADOOP_APP

#configures the core-site.xml file
echo "configuring core-site.xml"
sudo cat $HADOOP_CORE | sed '/<configuration>/d' | sed '/<\/configuration>/d' > $HADOOP_CORE.n
sudo echo '<configuration>' >> $HADOOP_CORE.n
sudo echo '<property>' >> $HADOOP_CORE.n
sudo echo '<name>hadoop.tmp.dir</name>' >> $HADOOP_CORE.n
sudo echo "<value>$HADOOP_APP</value>" >> $HADOOP_CORE.n
sudo echo '</property>' >> $HADOOP_CORE.n
sudo echo '<property>' >> $HADOOP_CORE.n
sudo echo '<name>fs.defaultFS</name>' >> $HADOOP_CORE.n
sudo echo "<value>hdfs://$nameNode:9000</value>" >> $HADOOP_CORE.n
sudo echo '</property>' >> $HADOOP_CORE.n
sudo echo '</configuration>' >> $HADOOP_CORE.n
sudo mv $HADOOP_CORE.n $HADOOP_CORE

#configures the hdfs-site.xml file
echo "configuring hdfs-site.xml"
sudo cat $HADOOP_HDFS | head -n-3 > $HADOOP_HDFS.n
sudo echo '<configuration>' >> $HADOOP_HDFS.n
sudo echo '<property>' >> $HADOOP_HDFS.n
sudo echo '<name>dfs.replication</name>' >> $HADOOP_HDFS.n
sudo echo '<value>2</value>' >> $HADOOP_HDFS.n
sudo echo '</property>' >> $HADOOP_HDFS.n
sudo echo '</configuration>' >> $HADOOP_HDFS.n
sudo mv $HADOOP_HDFS.n $HADOOP_HDFS

#configures the mapred-site.xml file
sudo mv $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_MAPR
sudo cat $HADOOP_MAPR | head -n-3 > $HADOOP_MAPR.n
sudo echo '<configuration>' >> $HADOOP_MAPR.n
sudo echo '<property>' >> $HADOOP_MAPR.n
sudo echo '<name>mapreduce.framework.name</name>' >> $HADOOP_MAPR.n
sudo echo '<value>yarn</value>' >> $HADOOP_MAPR.n
sudo echo '</property>' >> $HADOOP_MAPR.n
sudo echo '<property>' >> $HADOOP_MAPR.n
sudo echo '<name>mapreduce.jobtracker.address</name>' >> $HADOOP_MAPR.n
sudo echo '<value>$jobTracker:54311</value>' >> $HADOOP_MAPR.n
sudo echo '</property>' >> $HADOOP_MAPR.n
sudo echo '</configuration>' >> $HADOOP_MAPR.n
sudo mv $HADOOP_MAPR.n $HADOOP_MAPR

#configures the yarn-site.xml file
echo "configuring yarn-site.xml"
sudo cat $HADOOP_YARN | head -n-5 > $HADOOP_YARN.n
sudo echo '<configuration>' >> $HADOOP_YARN.n
sudo echo '<property>' >> $HADOOP_YARN.n
sudo echo '<name>yarn.nodemanager.aux-services</name>' >> $HADOOP_YARN.n
sudo echo '<value>mapreduce_shuffle</value>' >> $HADOOP_YARN.n
sudo echo '</property>' >> $HADOOP_YARN.n

sudo echo '<property>' >> $HADOOP_YARN.n
sudo echo '<name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>' >> $HADOOP_YARN.n
sudo echo '<value>org.apache.hadoop.mapred.ShuffleHandler</value>' >> $HADOOP_YARN.n
sudo echo '</property>' >> $HADOOP_YARN.n
sudo echo '<property>' >> $HADOOP_YARN.n
sudo echo '<name>yarn.resourcemanager.hostname</name>' >> $HADOOP_YARN.n
sudo echo "<value>$jobTracker</value>" >> $HADOOP_YARN.n
sudo echo '</property>' >> $HADOOP_YARN.n
sudo echo '</configuration>' >> $HADOOP_YARN.n
sudo mv $HADOOP_YARN.n $HADOOP_YARN

#configures slaves
echo "configuring slaves file"
sudo cat $clientList > $HADOOP_SLAV


#configures /etc/hosts
echo "configuring /etc/hosts"
sudo /bin/sh -c "cat hosts  >> /etc/hosts"

#ssh set up
#ssh-keygen -t rsa -P "" #i have already have keys on this system!
#cat /home/$(whoami)/.ssh/id_rsa.pub >> /home/$(whoami)/.ssh/authorized_keys

#start the system!
echo "starting the system"
#. /home/$(whoami)/.bashrc
#sleep 2
#hadoop namenode -format
#start-all.sh

#jps

#HDFS Stuff
echo "testing hdfs"
#cd /home/$(whoami)
#hdfs dfs -ls /
#hdfs dfs -mkdir /user
#hdfs dfs –ls /
#hdfs dfs -mkdir /user/$(whoami)/
#hdfs dfs -ls /user/
#echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." > demo.txt
#hdfs dfs -copyFromLocal demo.txt /user/$(whoami)/
#hdfs dfs -ls /user/$(whoami)/
#hdfs dfs -cat /user/$(whoami)/demo.txt
#stop-all.sh
