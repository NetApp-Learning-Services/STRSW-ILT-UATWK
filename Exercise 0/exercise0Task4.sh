# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment
# Execute by: ./exercise0Task4.sh

#!/bin/bash
DIR='/home/user/.kube' 
sudo apt install sshpass
sshpass -p Netapp1! scp -o "StrictHostKeyChecking=no" root@kubmas1-1:/root/.kube/config config1 
konfig=$(KUBECONFIG=config1 kubectl config view --flatten)
if [ ! -d "$DIR" ]; then
    mkdir -p $DIR;
fi
echo "$konfig" > $DIR/config
export KUBECONFIG=$DIR/configs