#!/bin/bash
# Set the context to the destination cluster
kubectl config use-context destination-admin@destination

# Define the namespace and secret name
NAMESPACE="trident-protect"
SECRET_NAME="gateway-s3-dst"

# Get the secret from Kubernetes
SECRET=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o json)

# Extract the accessKeyID and secretAccessKey
ACCESS_KEY_ID=$(echo $SECRET | jq -r '.data.accessKeyID' | base64 --decode)
SECRET_ACCESS_KEY=$(echo $SECRET | jq -r '.data.secretAccessKey' | base64 --decode)

# Print the keys
echo "Access Key ID: $ACCESS_KEY_ID"
echo "Secret Access Key: $SECRET_ACCESS_KEY"

# Set the context to the source cluster
kubectl config use-context source-admin@source

kubectl create secret generic -n trident-protect s3-dst-creds \
  --from-literal=accessKeyID=$ACCESS_KEY_ID \
  --from-literal=secretAccessKey=$SECRET_ACCESS_KEY