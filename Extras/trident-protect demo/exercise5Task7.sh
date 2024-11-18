echo "############################################"
echo "###         tridentctl install           ###"
echo "############################################"

curl -L -o tridentctl-protect https://github.com/NetApp/tridentctl-protect/releases/download/24.10.0/tridentctl-protect-linux-amd64
chmod +x tridentctl-protect
sudo mv ./tridentctl-protect /usr/local/bin/

mkdir -p ~/.trident-protect


curl -L -O https://github.com/NetApp/tridentctl-protect/releases/download/24.10.0/tridentctl-completion.bash
mkdir -p ~/.bash/completions
mv tridentctl-completion.bash ~/.bash/completions/
source ~/.bash/completions/tridentctl-completion.bash