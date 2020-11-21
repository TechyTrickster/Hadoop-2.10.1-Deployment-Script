#!/bin/bash

launchHadoopJob () {
    codeDir=$1
    mapper=$2
    reducer=$3
    data=$4
    output="/test/output-$(od -An -N8 -tu8 < /dev/urandom | tr -d ' ')"
    jar="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.10.1.jar"
    originalDir="$(pwd)"
    cd $codeDir
    #copy the input to hdfs
    hdfs dfs -put $codeDir/$data /data/$data
    #run the job
    hadoop jar $jar -mapper $codeDir/$mapper -file $mapper -reducer $codeDir/$reducer -file $reducer -input /data/$data -output $output
    #print all the output files to standard output
    hdfs dfs -ls $output | grep "$output" | grep "part" | grep -o "/.*" | parallel -P 1 "hdfs dfs -cat"
    cd $originalDir
}

export -f launchHadoopJob

cd /home/techytrickster/BigDataHomework2/
hdfs dfs -mkdir /test
launchHadoopJob "$(pwd)/task2code" mapper_phifer_A.py reducer_phifer_A.py passage.txt
launchHadoopJob "$(pwd)/task2code" mapper_phifer_B.py reducer_phifer_B.py purchases.txt
launchHadoopJob "$(pwd)/task2code" mapper_phifer_C.py reducer_phifer_C.py http_log.txt
launchHadoopJob "$(pwd)/task2code" mapper_phifer_D.py reducer_phifer_D.py iris.txt
