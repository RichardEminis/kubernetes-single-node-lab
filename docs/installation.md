# Installation Guide

Step-by-step guide to reproduce this Kubernetes cluster.

## Prerequisites

- Ubuntu 20.04/24.04 LTS
- 2+ CPU cores, 4GB+ RAM, 20GB+ disk
- Sudo access
- Internet connectivity

## Step 1: Prepare System
```bash
# Disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Load kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
```

## Step 2: Install Containerd
```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

# Install containerd
sudo apt-get install -y containerd

# Configure containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart containerd
sudo systemctl restart containerd
sudo systemctl enable containerd
```

## Step 3: Install Kubernetes
```bash
# Add Kubernetes repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubeadm, kubelet, kubectl
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

## Step 4: Initialize Cluster
```bash
# Initialize control plane
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Configure kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Allow scheduling on control plane (single-node)
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

## Step 5: Install Calico CNI
```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

# Wait for Calico pods
kubectl wait --for=condition=ready pod -l k8s-app=calico-node -n kube-system --timeout=300s
```

## Step 6: Install Ingress-Nginx
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/baremetal/deploy.yaml

# Wait for Ingress Controller
kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller -n ingress-nginx --timeout=300s
```

## Step 7: Deploy Demo Application
```bash
git clone https://github.com/YOUR_USERNAME/kubeadm-terraform-ansible-lab.git
cd kubeadm-terraform-ansible-lab
./scripts/deploy-demo.sh
```

## Step 8: Install Monitoring
```bash
./scripts/install-monitoring.sh
```

## Verification
```bash
./scripts/check-cluster.sh
```

Expected output: All pods Running, all services accessible.

## Access Applications

Add to hosts file (`/etc/hosts` or `C:\Windows\System32\drivers\etc\hosts`):
```
10.30.0.73 demo.local
```

Then access:
- Demo App: http://demo.local:30521
- Grafana: http://10.30.0.73:30903
- Prometheus: http://10.30.0.73:30900
