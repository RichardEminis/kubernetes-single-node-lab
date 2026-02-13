#!/bin/bash
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "     Deploying Demo Application"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if namespace exists
if ! kubectl get namespace demo &> /dev/null; then
    echo "Creating namespace 'demo'..."
    kubectl create namespace demo
    echo "Namespace created"
    echo ""
fi

# Apply manifests
echo "Applying ConfigMap..."
kubectl apply -f ../kubernetes/demo-nginx/configmap.yaml

echo "Applying Deployment..."
kubectl apply -f ../kubernetes/demo-nginx/deployment.yaml

echo "Applying Service..."
kubectl apply -f ../kubernetes/demo-nginx/service.yaml

echo "Applying Ingress..."
kubectl apply -f ../kubernetes/demo-nginx/ingress.yaml

echo ""
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/nginx-demo -n demo

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Demo Application Deployed Successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Status:"
kubectl get pods -n demo
echo ""
echo "Access URL:"
echo "http://demo.local:30521"
echo ""
echo "Make sure 'demo.local' is in your hosts file:"
echo "10.30.0.73 demo.local"
echo ""
