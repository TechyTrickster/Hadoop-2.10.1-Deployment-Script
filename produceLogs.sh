#!/bin/bash


ls -l /usr/local/hadoop
readlink -f $(whereis java | sed 's/java:\ //g' | tr ' ' '\n' | head -n1) | sed 's/\/bin\/java//g'
echo $JAVA_HOME
ls -l /app/hadoop/tmp
cat /usr/local/hadoop/etc/hadoop/core-site.xml
cat /usr/local/hadoop/etc/hadoop/hdfs-site.xml
cat /usr/local/hadoop/etc/hadoop/mapred-site.xml
cat /usr/local/hadoop/etc/hadoop/yarn-site.xml
jps

hdfs dfs -ls /
hdfs dfs -mkdir /user
hdfs dfs -ls /
hdfs dfs -mkdir /user/bigdata
hdfs dfs -ls /user/
neofetch > demo.txt
hdfs dfs -copyFromLocal demo.txt /user/bigdata/
hdfs dfs -ls /user/bigdata
hdfs dfs -cat /user/bigdata/demo.txt
