#!/bin/bash
set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Cleaning Up Old Resources from ingress-nginx namespace"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "ARNING: This will delete old demo app resources"
echo "from the ingress-nginx namespace."
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

echo ""
echo "eleting old deployment..."
kubectl delete deployment nginx-demo -n ingress-nginx --ignore-not-found=true

echo "eleting old service..."
kubectl delete service nginx-service -n ingress-nginx --ignore-not-found=true

echo "eleting old pods (if any)..."
kubectl delete pods -n ingress-nginx -l app=nginx-demo --ignore-not-found=true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "           Cleanup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Remaining resources in ingress-nginx:"
kubectl get all -n ingress-nginx
echo ""
