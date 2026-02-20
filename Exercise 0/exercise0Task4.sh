# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment
# Execute by: ./exercise0Task4.sh

#!/bin/bash
DIR='/home/user/.kube' 
sudo apt install sshpass
sshpass -p Netapp1! scp -o "StrictHostKeyChecking=no" root@kubmas1-1:/root/.kube/config config1 
sshpass -p Netapp1! scp -o "StrictHostKeyChecking=no" root@kubmas2-1:/root/.kube/config config2
sudo sed -i 's/\<kubernetes\>/source/g' config1 
sudo sed -i 's/\<kubernetes\>/destination/g' config2
konfig=$(KUBECONFIG=config1:config2 kubectl config view --flatten)
if [ ! -d "$DIR" ]; then
    mkdir -p $DIR;
fi
echo "$konfig" > $DIR/config
rm config1
rm config2

# This part of the script is used to add the certificate of the registry to the nodes and restart containerd
# Added becauase the nodes are not able to pull images from the registry due to the certificate not being trusted
CERT="/tmp/netapp-reg.crt"

NODES="kubmas1-1 kubwor1-1 kubwor1-2 kubwor1-3 kubmas2-1 kubwor2-1 kubwor2-2"

openssl s_client -showcerts -connect dockreg.labs.lod.netapp.com:443 </dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $CERT 

for NODE in $NODES; do sshpass -p 'Netapp1!' scp $CERT root@$NODE:/usr/local/share/ca-certificates/netapp-registry.crt
sshpass -p 'Netapp1!' ssh root@$NODE "update-ca-certificates && systemctl restart containerd" ;
done;
