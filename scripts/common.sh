#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)

set -euxo pipefail

# Variable Declaration

KUBERNETES_VERSION="1.25.2-00"

# disable swap
sudo swapoff -a

# keeps the swap off during reboot
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo apt-get update -y
sudo apt-get install gnupg2 curl -y
# Install containerd

# Create the .conf file to load the modules at bootup
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-containerd.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

sudo apt  update
sudo apt -y install containerd

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

sudo sed -i '/          \[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options\]/a\ \ \ \ \ \ \ \ \ \ \ \ SystemdCgroup = true' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd

echo "containerd runtime installed susccessfully"

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"
sudo apt-get update -y
sudo apt-get install -y jq

local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"
cat > /etc/default/kubelet << EOF
KUBELET_EXTRA_ARGS=--node-ip=$local_ip
EOF
