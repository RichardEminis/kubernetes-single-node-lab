#!/bin/bash
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "     Cleaning Up Demo Application"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Deleting Kubernetes resources..."
kubectl delete -f ../kubernetes/demo-nginx/ingress.yaml --ignore-not-found=true
kubectl delete -f ../kubernetes/demo-nginx/service.yaml --ignore-not-found=true
kubectl delete -f ../kubernetes/demo-nginx/deployment.yaml --ignore-not-found=true
kubectl delete -f ../kubernetes/demo-nginx/configmap.yaml --ignore-not-found=true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           Cleanup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Verify:"
echo "kubectl get all -n demo"
echo ""
