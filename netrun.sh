#!/bin/bash
clientList=$1
command=$2

mapfile -t clients < $clientList
for host in "${clients[@]}"; do
	name=$(ssh $host hostname)
	echo "-----$host----------^$name"
	ssh $host $command
	echo "--------------------"
done


