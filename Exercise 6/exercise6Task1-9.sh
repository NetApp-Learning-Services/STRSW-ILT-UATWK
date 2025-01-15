# This script has been written for this exercise environment 
# and is not intented to be used in a production enviroment
# Execute by: ./exercise6Task1-9.sh

#!/bin/bash
sudo apt install sshpass

for run in {1..2}; do
    echo "Run: kubwor2-$run"
    echo "Step 1"
    sshpass -p Netapp1! scp -o "StrictHostKeyChecking=no" multipath.conf root@kubwor2-$run:/etc/multipath.conf
    echo "Step 2"
    sshpass -p Netapp1! ssh root@kubwor1-$run "sudo systemctl enable --now iscsid multipathd"
    sshpass -p Netapp1! ssh root@kubwor1-$run "sudo service multipathd restart"
    echo "Step 3"
    sshpass -p Netapp1! ssh root@kubwor1-$run "cat /etc/iscsi/initiatorname.iscsi"
    echo "Step 4"
    sshpass -p Netapp1! ssh root@kubwor1-$run "sudo modprobe nvme-tcp"
    echo "Step 5"
    sshpass -p Netapp1! ssh root@kubwor1-$run "cat /etc/nvme/hostnqn"
done
