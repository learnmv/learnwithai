# LearnWithAI Kubernetes Deployment

## Quick Start

### Development Environment

```bash
# Build the backend image first
docker build -t learnwithai-backend:latest ./backend

# Deploy to Kubernetes
cd /home/sysadmin/learnwithai/k8s
kubectl apply -f dev.yml

# Check status
kubectl get pods -n learnwithai-dev

# Access services
# Backend API: http://localhost:30080
# PostgreSQL: localhost:30432
# Ollama: localhost:30434
```

### Production Environment

```bash
# IMPORTANT: Change secrets before deploying!
# Edit prod.yml and update:
# 1. postgres-secret password
# 2. backend-secret key
# 3. Ingress domain (learnwithai.app)

# Deploy to Kubernetes
cd /home/sysadmin/learnwithai/k8s
kubectl apply -f prod.yml

# Check status
kubectl get pods -n learnwithai-prod

# View logs
kubectl logs -f deployment/backend -n learnwithai-prod
```

## Service Access

### Development

| Service | NodePort | URL |
|---------|----------|-----|
| Backend API | 30080 | http://localhost:30080 |
| PostgreSQL | 30432 | localhost:30432 |
| Ollama | 30434 | localhost:30434 |

### Production

Access via Ingress domain (configure DNS to point to your cluster):
- API: https://learnwithai.app/api
- Health: https://learnwithai.app/health

## Configuration

### Development (dev.yml)

- **Single replica** for all services
- **EmptyDir** volumes (data lost on restart)
- **NodePort** for external access
- **CPU-only** Ollama (no GPU)
- **Simple passwords** (change for any shared environment)

### Production (prod.yml)

- **3 replicas** of backend (HA)
- **Persistent volumes** for PostgreSQL and Ollama
- **Secrets** for sensitive data
- **Resource limits** and **requests**
- **Health checks** (liveness, readiness, startup)
- **Horizontal Pod Autoscaler** (3-10 replicas)
- **Network policies** for security
- **Pod Disruption Budget** for availability
- **Rolling updates** strategy
- **Ingress** with SSL (configure cert-manager)

## Useful Commands

```bash
# Get all resources in dev namespace
kubectl get all -n learnwithai-dev

# Get all resources in prod namespace
kubectl get all -n learnwithai-prod

# View backend logs
kubectl logs -f deployment/backend -n learnwithai-dev

# Exec into PostgreSQL pod
kubectl exec -it deployment/postgres -n learnwithai-dev -- psql -U admin -d learnwithai

# Port forward for local access
kubectl port-forward svc/backend 8000:8000 -n learnwithai-dev

# Scale backend replicas
kubectl scale deployment backend --replicas=5 -n learnwithai-prod

# Delete namespace (cleanup)
kubectl delete namespace learnwithai-dev
kubectl delete namespace learnwithai-prod
```

## Production Checklist

Before deploying to production:

- [ ] Change `postgres-secret` password
- [ ] Change `backend-secret` key
- [ ] Update Ingress domain
- [ ] Configure TLS certificates (cert-manager)
- [ ] Set up external load balancer
- [ ] Configure monitoring (Prometheus/Grafana)
- [ ] Set up log aggregation (ELK/Loki)
- [ ] Enable network policies
- [ ] Configure backup for PostgreSQL PVC
- [ ] Set resource limits appropriately
- [ ] Test rolling updates
- [ ] Configure alerting

## Storage Classes

Adjust `storageClassName` in PVCs based on your cloud provider:

- **AWS**: gp2, gp3, io1
- **GCP**: standard, pd-ssd, pd-balanced
- **Azure**: default, managed-premium
- **On-prem**: nfs, ceph-rbd, etc.

## GPU Support (Optional)

For GPU-accelerated Ollama in production:

1. Install NVIDIA device plugin:
```bash
kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.0/nvidia-device-plugin.yml
```

2. Uncomment GPU resources in `prod.yml`:
```yaml
resources:
  limits:
    nvidia.com/gpu: 1
```

3. Add node selector:
```yaml
nodeSelector:
  nvidia.com/gpu.present: "true"
```

## Troubleshooting

### Pod stuck in Pending
- Check resource availability: `kubectl describe node`
- Check PVC status: `kubectl get pvc -n learnwithai-prod`

### Backend can't connect to PostgreSQL
- Verify service exists: `kubectl get svc postgres -n learnwithai-prod`
- Check backend logs: `kubectl logs deployment/backend -n learnwithai-prod`
- Test connection from backend pod

### Ollama models not downloading
- Check pod logs: `kubectl logs deployment/ollama -n learnwithai-prod`
- Verify internet connectivity
- Check PVC has enough space (20Gi)

### Ingress not working
- Verify ingress controller is installed
- Check ingress status: `kubectl get ingress -n learnwithai-prod`
- Check ingress controller logs
