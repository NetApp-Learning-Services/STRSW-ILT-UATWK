# execute by: ./mergeconfig.sh

#!/bin/bash
DIR='/home/user/.kube' 
sudo apt install sshpass
sshpass -p Netapp1! scp -o "StrictHostKeyChecking=no" root@kubmas1-1:/root/.kube/config config1 
sshpass -p Netapp1! scp -o "StrictHostKeyChecking=no" root@kubmas2-1:/root/.kube/config config2 
sudo sed -i 's/\<kubernetes\>/kubernetes2/g' config2
konfig=$(KUBECONFIG=config1:config2 kubectl config view --flatten)
if [ ! -d "$DIR" ]; then
    mkdir -p $DIR;
fi
echo "$konfig" > $DIR/config
#echo "$konfig" > config
$KUBECONFIG=$DIR/config