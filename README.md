# Hadoop-2.10.1-Deployment-Script
A set of script to install an Apache Hadoop 2.10.1 to a number of machines with (what I think are) sensible default.
limitation: the namenode and the resourcenode must be on the same physical host.  I have yet to find out why that is.  (it has nothing to do with any limitations of hadoop.
To make these scripts work you will need to make sure that each host on the cluster has ssh keys for every other host.
additionally, you will need to make a file containing the username@ipv4 pairs of all the hosts and users in the cluster.
finally, you will need a file containing the 'ipv4 host-name' pairs that will get added to each machines /etc/hosts.
beware. if you have made any major edits to your ~.bashrc file, maybe avoid this system, since the uninstaller will revert your ~.bashrc to the one contained in /etc/skel 
These scripts can also set up a single node hadoop system, all you need to do is just provide the info for one machine.
There are a few scripts here.  A mass uninstaller, massUninstall.sh, which just needs to be passed the list of 'username@ipv4' address pairs in the form of a file.
there is a mass installer, hadoopDeploy.sh, which needs the address and username of the namenode and resourcenode as arguments, and the hosts addition and client list files names as arguements
it would looks something like this at your command line; ./hadoopDeploy.sh <namenode> <resourcenode> <hostsfile> <clientlistfile>
  
the mass uninstaller would look like this; ./massUninstall.sh <clientlistfile>
