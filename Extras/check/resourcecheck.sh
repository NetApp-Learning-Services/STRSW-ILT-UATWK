# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment
# Execute by: ./resourcecheck.sh

#!/bin/bash

sudo apt install sshpass

for x in $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'); 
do 
  echo "Working on node:  $x"
  sshpass -p Netapp1! ssh -o "StrictHostKeyChecking=no" root@$x "cat /proc/meminfo | grep MemTotal; echo "processors: $(cat /proc/cpuinfo | grep processor | wc -l)";"
done