---
name: check-k8s
description: Check Kubernetes deployment status and logs
---

# Check K8s

Checks the status of LearnWithAI Kubernetes deployments.

## Usage

```
/check-k8s [dev|prod]
```

## Steps

1. Get pods: `kubectl get pods -n learnwithai-dev`
2. Get services: `kubectl get svc -n learnwithai-dev`
3. Show recent logs: `kubectl logs --tail=50 deployment/backend -n learnwithai-dev`
4. Check HPA (prod): `kubectl get hpa -n learnwithai-prod`

## Examples

```
/check-k8s dev     # Check development namespace
/check-k8s prod    # Check production namespace
/check-k8s         # Check both
```

## Useful Commands

- Port forward: `kubectl port-forward svc/backend 8000:8000 -n learnwithai-dev`
- Restart deployment: `kubectl rollout restart deployment/backend -n learnwithai-dev`
- Check rollout status: `kubectl rollout status deployment/backend -n learnwithai-dev`
