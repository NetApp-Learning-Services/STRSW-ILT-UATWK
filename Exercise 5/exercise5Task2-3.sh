#!/bin/bash
# Set the context to the source cluster
kubectl config use-context source-admin@source

# Define the namespace and secret name
NAMESPACE="trident-protect"
SECRET_NAME="gateway-s3-src"

# Get the secret from Kubernetes
SECRET=$(kubectl get secret $SECRET_NAME -n $NAMESPACE -o json)

# Extract the accessKeyID and secretAccessKey
ACCESS_KEY_ID=$(echo $SECRET | jq -r '.data.accessKeyID' | base64 --decode)
SECRET_ACCESS_KEY=$(echo $SECRET | jq -r '.data.secretAccessKey' | base64 --decode)

# Print the keys
echo "Access Key ID: $ACCESS_KEY_ID"
echo "Secret Access Key: $SECRET_ACCESS_KEY"

# Set aws-cli credentials
aws configure set aws_access_key_id $ACCESS_KEY_ID --profile src
aws configure set aws_secret_access_key $SECRET_ACCESS_KEY --profile src
aws configure set output text --profile src