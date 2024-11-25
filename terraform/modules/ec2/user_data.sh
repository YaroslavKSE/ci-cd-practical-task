#!/bin/bash

# Update system packages
sudo dnf update -y

# Install Docker
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install kubectl
# Create kubectl repo
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF

# Install kubectl
sudo yum install -y kubectl

# Install required dependencies
sudo dnf install -y conntrack

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start Minikube
sudo -u ec2-user minikube start --driver=docker --cpus=2 --memory=2048

# Create directory for K8s manifests
mkdir -p /k8s-manifests

# Install Nginx
sudo dnf install -y nginx

# Create Nginx configuration
cat << EOF | sudo tee /etc/nginx/conf.d/kubernetes.conf
server {
    listen 80;
    server_name k8s.academichub.net;

    location / {
        proxy_pass http://127.0.0.1:30000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Start Nginx
sudo systemctl enable nginx
sudo systemctl start nginx