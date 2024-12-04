#!/bin/bash
# Update system packages
sudo dnf update -y

# Install Docker
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user

# Install kubectl
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF
sudo yum install -y kubectl

# Install required dependencies
sudo dnf install -y conntrack

# Install Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Create .kube directory for ec2-user
sudo -u ec2-user mkdir -p /home/ec2-user/.kube
sudo chown -R ec2-user:ec2-user /home/ec2-user/.kube

# Create directory for K8s manifests and set permissions
mkdir -p /k8s-manifests
chown -R ec2-user:ec2-user /k8s-manifests

# Download K8s manifests from S3
aws s3 cp s3://k8s-deployment-manifests/rocketdex/deployment.yaml /k8s-manifests/
aws s3 cp s3://k8s-deployment-manifests/rocketdex/service.yaml /k8s-manifests/

# Stop and delete any existing minikube cluster
sudo -u ec2-user minikube stop || true
sudo -u ec2-user minikube delete || true

# Start Minikube with specific configuration
sudo -u ec2-user CHANGE_MINIKUBE_NONE_USER=true minikube start \
  --driver=docker \
  --cpus=2 \
  --memory=2048 \
  --kubernetes-version=stable

# Wait for minikube to be ready
sleep 10

# Configure kubectl
sudo -u ec2-user minikube update-context
sudo cp -i $(sudo -u ec2-user minikube kubectl -- config view --raw -o json | jq -r '.clusters[0].cluster."certificate-authority"') /home/ec2-user/.minikube/ca.crt
sudo chown ec2-user:ec2-user /home/ec2-user/.minikube/ca.crt

# Apply K8s manifests with validation disabled for initial deployment
sudo -u ec2-user kubectl apply -f /k8s-manifests/

# Apply K8s manifests
kubectl apply -f /k8s-manifests/

# Install Nginx
sudo dnf install -y nginx

# Get minikube IP and create Nginx configuration
MINIKUBE_IP=$(sudo -u ec2-user minikube ip)
cat << EOF | sudo tee /etc/nginx/conf.d/kubernetes.conf
server {
    listen 80;
    server_name k8s.academichub.net;
    location / {
        proxy_pass http://${MINIKUBE_IP}:30000;
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