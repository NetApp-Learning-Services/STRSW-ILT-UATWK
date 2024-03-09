#!/bin/bash 
sudo apt install sshpass
sshpass -p Netapp1! scp root@kubmas1-1:/root/.kube/config config1
sshpass -p Netapp1! scp root@kubmas2-1:/root/.kube/config config2
sudo sed -i 's/\<kubernetes\>/kubernetes2/g' config2
konfig=$(KUBECONFIG=config1:config2 kubectl config view --flatten)
echo "$konfig" > ~/.kube/config
#echo "$konfig" > config
$KUBECONFIG=~/.kube/config