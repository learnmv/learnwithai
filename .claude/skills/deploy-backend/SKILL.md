---
name: deploy-backend
description: Build and deploy the FastAPI backend to Kubernetes
---

# Deploy Backend

Builds the Docker image and deploys/updates the backend in Kubernetes.

## Usage

```
/deploy-backend [dev|prod]
```

## Steps

1. Build Docker image: `docker build -t learnwithai-backend:latest ./backend`
2. Apply K8s manifest: `kubectl apply -f k8s/dev.yml` (or prod.yml)
3. Verify deployment: `kubectl get pods -n learnwithai-dev`
4. Check logs: `kubectl logs -f deployment/backend -n learnwithai-dev`

## Examples

```
/deploy-backend dev      # Deploy to development (1 replica)
/deploy-backend prod     # Deploy to production (3 replicas + HPA)
```

## Notes

- Requires Docker and kubectl access
- PostgreSQL and Ollama must be running on host (10.0.0.131)
- Uses NodePort 30080 for external access
