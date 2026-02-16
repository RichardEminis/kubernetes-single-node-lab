# Troubleshooting Guide

## Common Issues

### 1. Pods Stuck in Pending

**Symptom:**
```bash
kubectl get pods -n demo
# Shows "Pending" status
```

**Diagnosis:**
```bash
kubectl describe pod <pod-name> -n demo
```

**Solutions:**
- Check if node has enough resources
- Verify CNI is running: `kubectl get pods -n kube-system | grep calico`
- Remove taints: `kubectl taint nodes --all node-role.kubernetes.io/control-plane-`

---

### 2. Demo App Not Accessible

**Symptom:** Cannot access http://demo.local:30521

**Checklist:**
1. Check pods: `kubectl get pods -n demo`
2. Check service: `kubectl get svc -n demo`
3. Check ingress: `kubectl get ingress -n demo`
4. Check hosts file: `10.30.0.73 demo.local`

**Test from server:**
```bash
curl -H "Host: demo.local" http://localhost:30521
```

---

### 3. Monitoring Not Working

**Prometheus targets down:**
- Check: http://10.30.0.73:30900/targets
- Some targets (kube-controller-manager, scheduler) may be down - this is normal for kubeadm

**Grafana not accessible:**
```bash
kubectl get pods -n monitoring
kubectl logs -n monitoring -l app.kubernetes.io/name=grafana
```

---

### 4. Node NotReady

**Diagnosis:**
```bash
kubectl describe node
systemctl status kubelet
journalctl -u kubelet -f
```

**Common fixes:**
```bash
sudo systemctl restart kubelet
sudo systemctl restart containerd
```

---

### 5. Ingress Controller Issues

**Check logs:**
```bash
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller
```

**Restart:**
```bash
kubectl rollout restart deployment ingress-nginx-controller -n ingress-nginx
```

---

## Useful Commands

### Pod Debugging
```bash
# Get pod details
kubectl describe pod <name> -n <namespace>

# View logs
kubectl logs <name> -n <namespace>

# Exec into pod
kubectl exec -it <name> -n <namespace> -- /bin/sh

# Previous container logs
kubectl logs <name> -n <namespace> --previous
```

### Network Testing
```bash
# Test DNS
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup kubernetes.default

# Test connectivity
kubectl run -it --rm debug --image=nicolaka/netshoot --restart=Never -- bash
```

### Cluster Reset (Last Resort)
```bash
sudo kubeadm reset
sudo rm -rf /etc/cni/net.d
sudo rm -rf $HOME/.kube/config
# Then reinstall from scratch
```

---

## Getting Help

- Kubernetes Docs: https://kubernetes.io/docs/
- Calico Docs: https://docs.tigera.io/calico/
- Ingress-Nginx Docs: https://kubernetes.github.io/ingress-nginx/
