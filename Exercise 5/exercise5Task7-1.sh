echo "############################################"
echo "###     tridentctl-protect install       ###"
echo "############################################"

VERSION=24.10.1

curl -L -o tridentctl-protect https://github.com/NetApp/tridentctl-protect/releases/download/$VERSION/tridentctl-protect-linux-amd64
chmod +x tridentctl-protect
sudo mv ./tridentctl-protect /usr/local/bin/

mkdir -p ~/.trident-protect

curl -L -O https://github.com/NetApp/tridentctl-protect/releases/download/$VERSION/tridentctl-completion.bash
mkdir -p ~/.bash/completions
mv tridentctl-completion.bash ~/.bash/completions/
source ~/.bash/completions/tridentctl-completion.bash