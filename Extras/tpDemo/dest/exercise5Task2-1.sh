BUCKETKEY=change_me
BUCKETSECRET=change_me

kubectl create secret generic -n trident-protect s3-src-creds \
  --from-literal=accessKeyID=$BUCKETKEY \
  --from-literal=secretAccessKey=$BUCKETSECRET