# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment
# Execute by: ./2.sh

#!/bin/bash

echo "############################################"
echo "###     Print Node KubeVirt Labels       ###"
echo "############################################"

for node in $(kubectl get nodes -o jsonpath='{.items[*].metadata.name}'); do 
  echo "Node: $node"
  kubectl get node $node -o jsonpath='{.metadata.labels}' | tr ',' '\n' | grep -E "kubevirt"  | sed 's/^[ \t]*//;s/[ \t]*$//' ; 
  echo; 
done