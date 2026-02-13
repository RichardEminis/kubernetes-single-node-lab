#!/bin/bash
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "     Installing Monitoring Stack"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "Helm is not installed!"
    echo ""
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "Helm installed"
    echo ""
fi

# Add Prometheus repository
echo "Adding Prometheus Helm repository..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo ""
echo "Installing kube-prometheus-stack..."
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set prometheus.service.type=NodePort \
  --set prometheus.service.nodePort=30900 \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30903 \
  --set grafana.adminPassword=admin \
  --set alertmanager.enabled=false

echo ""
echo "Waiting for pods to be ready (this may take 2-5 minutes)..."
sleep 10
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=grafana -n monitoring --timeout=300s

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "     Monitoring Stack Installed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "   Access URLs:"
echo "   Prometheus: http://10.30.0.73:30900"
echo "   Grafana:    http://10.30.0.73:30903"
echo ""
echo "   Grafana Credentials:"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo "   Check status:"
echo "   kubectl get pods -n monitoring"
echo ""
