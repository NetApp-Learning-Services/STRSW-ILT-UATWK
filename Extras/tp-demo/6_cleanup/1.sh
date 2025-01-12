#!/bin/bash

echo "############################################"
echo "###         clean up src bucket          ###"
echo "############################################"

# Define the bucket name and endpoint URL
BUCKET_NAME="tp-src"
ENDPOINT_URL="https://192.168.0.74"
PROFILE="src"

# List all objects in the bucket and extract their keys
OBJECT_KEYS=$(aws --endpoint-url $ENDPOINT_URL s3api list-objects-v2 --bucket $BUCKET_NAME --no-verify-ssl --profile $PROFILE --query 'Contents[].Key' --output text)

# Delete each object
for KEY in $OBJECT_KEYS; do
  aws --endpoint-url $ENDPOINT_URL s3api delete-object --bucket $BUCKET_NAME --key $KEY --no-verify-ssl --profile $PROFILE
done

echo "All files have been deleted from the bucket $BUCKET_NAME."

echo "############################################"
echo "###         clean up dst bucket          ###"
echo "############################################"

# Define the bucket name and endpoint URL
BUCKET_NAME="tp-dst"
ENDPOINT_URL="https://192.168.0.84"
PROFILE="dst"

# List all objects in the bucket and extract their keys
OBJECT_KEYS=$(aws --endpoint-url $ENDPOINT_URL s3api list-objects-v2 --bucket $BUCKET_NAME --no-verify-ssl --profile $PROFILE --query 'Contents[].Key' --output text)

# Delete each object
for KEY in $OBJECT_KEYS; do
  aws --endpoint-url $ENDPOINT_URL s3api delete-object --bucket $BUCKET_NAME --key $KEY --no-verify-ssl --profile $PROFILE
done

echo "All files have been deleted from the bucket $BUCKET_NAME."