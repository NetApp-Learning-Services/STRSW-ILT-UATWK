echo "############################################"
echo "###      Trident Protect install         ###"
echo "############################################"

CLUSTERNAME=destination
PROTECTNS=trident-protect
PROTECTVERSION=100.2602.0

helm repo add netapp-trident-protect https://netapp.github.io/trident-protect-helm-chart

helm install trident-protect netapp-trident-protect/trident-protect \
    --set clusterName=$CLUSTERNAME \
    --version $PROTECTVERSION      \
    --namespace $PROTECTNS         \
    --create-namespace  