BUCKETKEY=3QI7R21HP84FSETSSLB6
BUCKETSECRET=o53LdNCZ2IQh7mhnKI3q7NpOLrXnG08UIRSZx3q2

kubectl create secret generic -n trident-protect s3-src-creds \
  --from-literal=accessKeyID=$BUCKETKEY \
  --from-literal=secretAccessKey=$BUCKETSECRET