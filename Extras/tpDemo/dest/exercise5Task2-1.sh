BUCKETKEY2=0CQQK317HZKNWLYHC42L
BUCKETSECRET2=hZdAzz_ng5xNtSAe64_Ph_gcDM_Cg33445CO0pdI

kubectl create secret generic -n trident-protect s3-dest-creds \
  --from-literal=accessKeyID=$BUCKETKEY2 \
  --from-literal=secretAccessKey=$BUCKETSECRET2