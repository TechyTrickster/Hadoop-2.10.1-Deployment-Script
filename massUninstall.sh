#!/bin/bash

remove () {
	host=$1
	echo $host
	user=$(echo $host | grep -o ".*@" | tr -d '@')
	scp uninstall.sh $host:/home/$user
	ssh $host chmod +x uninstall.sh
	ssh -t $host "./uninstall.sh"
	#ssh -t $host "sudo apt update"
}


export -f remove
mapfile -t clients < clientList.txt
for host in "${clients[@]}"; do
	remove $host
done
