## 📁 Project Structure
```
kubeadm-terraform-ansible-lab/
├── README.md
├── architecture/
│   └── diagram.md
├── kubernetes/
│   ├── demo-nginx/
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   ├── configmap.yaml
│   │   ├── namespace.yaml
│   │   └── service.yaml
├── scripts/
│   ├── check-cluster.sh
│   ├── cleanup-demo.sh
│   ├── cleanup-old-resources.sh
│   ├── deploy-demo.sh
│   ├── generate-load.sh
│   ├── install-monitoring.sh
└── docs/
    ├── installation.md
    ├── troubleshooting.md
    ├── cni-calico.md
    ├── environment.md
    ├── single-node-worker.md
    ├── container-runtime.md
    ├── k8s-prerequisites.md
    ├── kubernetes-components.md
    └── kubeadm-init.md
