#!/bin/bash

set -e

VMS=("ap-worker-node1" "ap-worker-node2")

for VM in "${VMS[@]}"; do
    echo "Stopping $VM"
    VBoxManage controlvm "$VM" poweroff
    sleep 5
done

echo "All nodes has been successfully stopped."
