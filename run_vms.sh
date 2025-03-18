#!/bin/bash

set -e

VMS=("ap-worker-node1" "ap-worker-node2")

for VM in "${VMS[@]}"; do
    echo "Starting $VM"
    VBoxManage startvm "$VM" --type headless
    sleep 5
done

echo "All nodes has been successfully started."
