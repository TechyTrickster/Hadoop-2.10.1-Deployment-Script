#!/bin/bash
sudo rm -r /app/hadoop
sudo rm -r /usr/local/hadoop
rm /home/$(whoami)/clientList.txt
rm /home/$(whoami)/hadoopInstaller.sh
#cat /home/$(whoami)/.bashrc | head -n-3 > /home/$(whoami)/.bashrc.n
cp /etc/skel/.bashrc /home/$(whoami)/.bashrc
sudo cp /etc/skel/hosts /etc/hosts
#mv /home/$(whoami)/.bashrc.n /home/$(whoami)/.bashrc
#rm /home/$(whoami)/uninstall.sh
kill $(jps | sed '/Jps/d' | sed 's/ .*//g' | tr '\n' ' ')
