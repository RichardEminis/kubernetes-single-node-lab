#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "    🔍 Kubernetes Cluster Status"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📊 Nodes:"
kubectl get nodes
echo ""

echo "📦 Namespaces:"
kubectl get namespaces
echo ""

echo "🏃 All Pods:"
kubectl get pods -A
echo ""

echo "🌐 Services:"
kubectl get svc -A
echo ""

echo "🔀 Ingresses:"
kubectl get ingress -A
echo ""

echo "📈 Resource Usage:"
kubectl top nodes
echo ""
kubectl top pods -n demo
echo ""
