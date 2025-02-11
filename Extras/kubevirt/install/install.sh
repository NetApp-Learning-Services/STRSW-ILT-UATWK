# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment
# Execute by: ./install.sh

#!/bin/bash

DEST_DIR="/usr/local/bin"

echo "############################################"
echo "###          KubeVirt install            ###"
echo "############################################"

KUBEVIRT_VERSION=$(curl -s https://api.github.com/repos/kubevirt/kubevirt/releases/latest | awk -F '[ \t":]+' '/tag_name/ {print $3}')
echo "KubeVirt version: $KUBEVIRT_VERSION"

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-operator.yaml

kubectl create -f https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/kubevirt-cr.yaml 

echo "############################################"
echo "###          virtctl install             ###"
echo "############################################"

curl -Lo virtctl https://github.com/kubevirt/kubevirt/releases/download/${KUBEVIRT_VERSION}/virtctl-${KUBEVIRT_VERSION}-linux-amd64

sudo chmod +x virtctl
sudo mv virtctl $DEST_DIR

echo "File virtctl-${KUBEVIRT_VERSION}-linux-amd64 has been extracted, moved to $DEST_DIR, and made executable."

echo "############################################"
echo "###  Containerized Data Importer install ###"
echo "############################################"

export CDI_VERSION=$(curl -Ls https://github.com/kubevirt/containerized-data-importer/releases/latest | grep -m 1 -o "v[0-9]\.[0-9]*\.[0-9]*")
echo "Containerized Data Importer version: $CDI_VERSION"

kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$CDI_VERSION/cdi-operator.yaml