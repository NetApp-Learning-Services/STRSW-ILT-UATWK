BUCKETKEY=DD3EQ31PWKMKZ9HAB3A8
BUCKETSECRET=_3cnR9rXTztJB3gKBxuSeWAysZxPXTpq_DYdJsi9

kubectl create secret generic -n trident-protect s3-dest-creds \
  --from-literal=accessKeyID=$BUCKETKEY2 \
  --from-literal=secretAccessKey=$BUCKETSECRET2