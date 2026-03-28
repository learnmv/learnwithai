# LearnWithAI Kubernetes Deployment

## Architecture

This K8s setup deploys only the **FastAPI backend** to your existing cluster.
**PostgreSQL** and **Ollama** are already running on the host (10.0.0.131).

```
┌─────────────────────────────────────────┐
│              Kubernetes                 │
│  ┌─────────────────────────────────┐   │
│  │   learnwithai-dev/prod NS       │   │
│  │   ┌─────────────────────┐       │   │
│  │   │   Backend Pods      │       │   │
│  │   │   (3 replicas)      │       │   │
│  │   └──────────┬──────────┘       │   │
│  │              │                  │   │
│  └──────────────┼──────────────────┘   │
│                 │                       │
│  ┌──────────────┴──────────────────┐   │
│  │        NodePort 30080            │   │
│  └──────────────┬──────────────────┘   │
└─────────────────┼───────────────────────┘
                  │
         ┌────────┴────────┐
         │  Host Services  │
         │  ┌───────────┐  │
         │  │ PostgreSQL│  │ Port: 30432
         │  │ 10.0.0.131│  │
         │  └───────────┘  │
         │  ┌───────────┐  │
         │  │   Ollama  │  │ Port: 30434
         │  │ 10.0.0.131│  │
         │  └───────────┘  │
         └─────────────────┘
```

## Quick Start

### 1. Build Backend Image

```bash
cd /home/sysadmin/learnwithai/backend
docker build -t learnwithai-backend:latest .
```

### 2. Deploy to Kubernetes

#### Development (1 replica)

```bash
cd /home/sysadmin/learnwithai/k8s
kubectl apply -f dev.yml

# Check status
kubectl get pods -n learnwithai-dev

# View logs
kubectl logs -f deployment/backend -n learnwithai-dev
```

#### Production (3 replicas, HPA)

```bash
# IMPORTANT: Change the secret key first!
# Edit prod.yml and update backend-secret

kubectl apply -f prod.yml

# Check status
kubectl get pods -n learnwithai-prod
kubectl get hpa -n learnwithai-prod
```

### 3. Access the API

```bash
# Via NodePort
curl http://10.0.0.131:30080/health

# Or via kubectl port-forward
kubectl port-forward svc/backend 8000:8000 -n learnwithai-dev
# Then visit http://localhost:8000/docs
```

## Configuration

### Connection Strings

Both `dev.yml` and `prod.yml` connect to existing services:

| Service | Host | Port | Connection |
|---------|------|------|------------|
| PostgreSQL | 10.0.0.131 | 30432 | Already running on host |
| Ollama | 10.0.0.131 | 30434 | Already running on host |

### Backend Service

| Environment | Type | NodePort | Replicas |
|-------------|------|----------|----------|
| dev | NodePort | 30080 | 1 |
| prod | NodePort | 30080 | 3 (HPA: 3-10) |

## Useful Commands

```bash
# Get all resources
kubectl get all -n learnwithai-dev
kubectl get all -n learnwithai-prod

# View logs
kubectl logs -f deployment/backend -n learnwithai-dev

# Scale manually
kubectl scale deployment backend --replicas=5 -n learnwithai-prod

# Delete deployment
kubectl delete -f dev.yml
kubectl delete -f prod.yml

# Check HPA status
kubectl get hpa backend-hpa -n learnwithai-prod
kubectl describe hpa backend-hpa -n learnwithai-prod

# Port forward for local testing
kubectl port-forward svc/backend 8000:8000 -n learnwithai-dev
```

## Production Checklist

Before deploying to production:

- [ ] Change `backend-secret` in `prod.yml`
- [ ] Verify PostgreSQL is accessible at `10.0.0.131:30432`
- [ ] Verify Ollama is accessible at `10.0.0.131:30434`
- [ ] Set appropriate CORS origins in ConfigMap
- [ ] Test with `curl http://10.0.0.131:30080/health`
- [ ] Verify HPA is working: `kubectl get hpa -n learnwithai-prod`
- [ ] Set up external load balancer (nginx/traefik) if needed
- [ ] Configure SSL/TLS termination

## Troubleshooting

### Backend can't connect to PostgreSQL

```bash
# Test connectivity from pod
kubectl exec -it deployment/backend -n learnwithai-dev -- sh
# Then inside pod:
apk add --no-cache postgresql-client
psql "postgresql://admin:admin@123@10.0.0.131:30432/learnwithai" -c "SELECT 1;"
```

### Backend can't connect to Ollama

```bash
# Test from pod
kubectl exec -it deployment/backend -n learnwithai-dev -- sh
# Then:
apk add --no-cache curl
curl http://10.0.0.131:11434/api/tags
```

### ImagePullBackOff

```bash
# Ensure image is built on the node
docker build -t learnwithai-backend:latest ./backend
docker images | grep learnwithai-backend
```

### Pod in CrashLoopBackOff

```bash
# Check logs
kubectl logs deployment/backend -n learnwithai-dev --previous

# Check events
kubectl describe pod -l app=backend -n learnwithai-dev
```

## Updating Deployment

```bash
# Rebuild image
docker build -t learnwithai-backend:latest ./backend

# Rolling update
kubectl rollout restart deployment/backend -n learnwithai-dev

# Check rollout status
kubectl rollout status deployment/backend -n learnwithai-dev
```
