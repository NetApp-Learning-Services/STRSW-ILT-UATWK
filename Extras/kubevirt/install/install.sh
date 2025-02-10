# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment
# Execute by: ./install.sh

#!/bin/bash

KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | awk -F '[ \t":]+' '/tag_name/ {print $3}')
echo "KubeVirt version: $KUBEVIRT_VERSION"

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml 

curl -Lo virtctl https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/virtctl-${KUBEVIRT_VERSION}-linux-amd64

sudo chmod +x virtctl
sudo mv virtctl /usr/local/bin