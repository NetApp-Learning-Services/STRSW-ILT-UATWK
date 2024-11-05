BUCKETKEY=Q5BD141RZBUH70T2V6PS
BUCKETSECRET=7ax3tUyGlaCFA2Dn9YpQp3c7A2RWZJ_c1TcsCTxz

kubectl create secret generic -n trident-protect s3-src-creds \
  --from-literal=accessKeyID=$BUCKETKEY \
  --from-literal=secretAccessKey=$BUCKETSECRET