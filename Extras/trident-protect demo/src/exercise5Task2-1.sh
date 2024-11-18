BUCKETKEY=EWEF3217OICBTNOVDIGC
BUCKETSECRET=_c1n_03Cp_zuV_tK3gjTqBz49ctaEWluFZ3GBdpA

kubectl create secret generic -n trident-protect s3-src-creds \
  --from-literal=accessKeyID=$BUCKETKEY \
  --from-literal=secretAccessKey=$BUCKETSECRET