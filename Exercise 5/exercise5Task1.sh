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