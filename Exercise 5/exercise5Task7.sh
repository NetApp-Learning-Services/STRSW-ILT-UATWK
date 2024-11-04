echo "############################################"
echo "###         Protectctl install           ###"
echo "############################################"

ACCOUNTID=d13e74bf-3ced-488d-b31a-8ed307395e93
TOKEN=hwTgNdnLXQEa8mD5h_YxOSuhBNakxQfA-npBgHU6Dsg=
PROTECTVERSION=24.10.0-preview.1

podman login -u $ACCOUNTID -p $TOKEN cr.astra.netapp.io
podman pull cr.astra.netapp.io/trident-protectctl:$PROTECTVERSION
podman run --rm -v $(pwd):/pctl-tmp cr.astra.netapp.io/trident-protectctl:$PROTECTVERSION cp protectctl /pctl-tmp
mv protectctl /usr/local/bin

mkdir -p ~/.trident-protect
echo 'namespace: trident-protect' > ~/.trident-protect/protectctl.yaml

cat <<EOT >> ~/.bashrc
source <(protectctl completion bash)
EOT
source ~/.bashrc