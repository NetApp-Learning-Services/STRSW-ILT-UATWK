echo "############################################"
echo "###         tridentctl install           ###"
echo "############################################"

curl -L -o tridentctl-protect https://github.com/NetApp/tridentctl-protect/releases/download/24.10.0/tridentctl-protect-linux-amd64
chmod +x tridentctl-protect
sudo mv ./tridentctl-protect /usr/local/bin/

mkdir -p ~/.trident-protect
echo 'namespace: trident-protect' > ~/.trident-protect/protectctl.yaml

cat <<EOT >> ~/.bashrc
source <(protectctl completion bash)
EOT
source ~/.bashrc