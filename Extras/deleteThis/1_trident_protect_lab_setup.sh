
# PARAMETERS: 
# PARAMETER1: Docker hub login
# PARAMETER2: Docker hub password

if [[ $# -ne 2 ]];then
      echo "Please restart the script with the following parameters:"
      echo " - Parameter1: Docker hub login"
      echo " - Parameter2: Docker hub password"
      exit 0
fi

ping -c1 -W1 -q rhel4 &>/dev/null
if [[ $? == 1 ]];then
  echo "#################################################################"
  echo "# You first need to start RHEL4 from the LoD MyLabs page"
  echo "#################################################################"
  exit 0
fi
ping -c1 -W1 -q rhel5 &>/dev/null
if [[ $? == 1 ]];then
  echo "#################################################################"
  echo "# You first need to start RHEL5 from the LoD MyLabs page"
  echo "#################################################################"
  exit 0
fi

echo "############################################"
echo "### Windows Nodes: Taint: No Schedule"
echo "############################################"
kubectl taint nodes win1 win=true:NoSchedule
kubectl taint nodes win2 win=true:NoSchedule

cd
git clone https://github.com/YvosOnTheHub/LabNetApp.git

cd LabNetApp
./all_in_one_v6.sh $1 $2

cd /root/LabNetApp/Kubernetes_v6/Scenarios/Scenario24
sh scenario24_pull_images.sh $1 $2
sh setup_sc24_svm.sh

echo "############################################"
echo "### Trident Protect install"
echo "############################################"

kubectl create ns trident-protect

ACCOUNTID=d13e74bf-3ced-488d-b31a-8ed307395e93
TOKEN=hwTgNdnLXQEa8mD5h_YxOSuhBNakxQfA-npBgHU6Dsg=

helm registry login cr.astra.netapp.io -u $ACCOUNTID -p $TOKEN
kubectl create secret docker-registry regcred --docker-username=$ACCOUNTID --docker-password=$TOKEN -n trident-protect --docker-server=cr.astra.netapp.io

helm install trident-protect-crds oci://cr.astra.netapp.io/trident-protect-crds \
  --version 24.10.0-preview.1 \
  --set controller.image.registry=cr.astra.netapp.io 

helm install trident-protect -n trident-protect oci://cr.astra.netapp.io/trident-protect --version 24.10.0-preview.1 \
  --set controller.image.registry=cr.astra.netapp.io \
  --set 'imagePullSecrets[0].name=regcred' \
  --set clusterName=lod1
  
kubectl patch deployments -n trident-protect trident-protect-controller-manager -p '{"spec": {"template": {"spec": {"nodeSelector": {"kubernetes.io/os": "linux"}}}}}'

echo "############################################"
echo "### Protectctl install"
echo "############################################"
cd
podman login -u $ACCOUNTID -p $TOKEN cr.astra.netapp.io
podman pull cr.astra.netapp.io/trident-protectctl:24.10.0-preview.1
podman run --rm -v $(pwd):/pctl-tmp cr.astra.netapp.io/trident-protectctl:24.10.0-preview.1 cp protectctl /pctl-tmp
mv protectctl /usr/local/bin

mkdir -p ~/.trident-protect
echo 'namespace: trident-protect' > ~/.trident-protect/protectctl.yaml

cat <<EOT >> ~/.bashrc
source <(protectctl completion bash)
EOT
source ~/.bashrc

echo "############################################"
echo "### Volume Snapshot Class Creation"
echo "############################################"
kubectl create -f /root/LabNetApp/Kubernetes_v6/Scenarios/Scenario13/1_CSI_Snapshots/sc-volumesnapshot.yaml

echo "####################################################"
echo "### Clone Verda"
echo "####################################################"
git clone https://github.com/NetApp/Verda

echo
echo "############################################"
echo "### SVM S3 + Bucket Creation"
echo "############################################"
cd /root/LabNetApp/Kubernetes_v6/Addendum/Addenda09
ansible-playbook svm_S3_setup.yaml > ansible_result.txt

BUCKETKEY=$(grep "access_key" ansible_result.txt | cut -d ":" -f 2 | cut -b 2- | sed 's/..$//')
BUCKETSECRET=$(grep "secret_key" ansible_result.txt | cut -d ":" -f 2 | cut -b 2- | sed 's/..$//')

echo "BUCKETKEY= $BUCKETKEY"
echo "BUCKETSECRET= $BUCKETSECRET"

echo "############################################"
echo "### TrPr: First bucket config"
echo "############################################"
kubectl create secret generic -n trident-protect s3-creds \
  --from-literal=accessKeyID=$BUCKETKEY \
  --from-literal=secretAccessKey=$BUCKETSECRET
  
protectctl create appvault ontap-s3 ontap-s3-appvault -b s3lod -e 192.168.0.230 --skip-cert-validation -s s3-creds  --no-tls

echo "############################################"
echo "### AWS S3 Tool install & configure"
echo "############################################"
cd
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf aws

mkdir ~/.aws
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = $BUCKETKEY
aws_secret_access_key = $BUCKETSECRET
EOF

echo
echo "#####################################################"
echo "# Copy second K8S cluster setup script to RHEL5"
echo "#####################################################"

curl -s --insecure --user root:Netapp1! -T /root/2_trident_protect_lab_setup_rhel5.sh sftp://rhel5/root/

echo
echo "#####################################################"
echo "# Launch second cluster setup"
echo "#####################################################"

ssh -o "StrictHostKeyChecking no" root@rhel5 -t "sh 2_trident_protect_lab_setup_rhel5.sh $BUCKETKEY $BUCKETSECRET"