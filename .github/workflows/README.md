# GitHub Actions CI/CD Workflows

## Overview

This CI/CD setup uses **GitHub Actions** to build, test, and deploy both frontend and backend services to **GitHub Container Registry (GHCR)**.

## Workflow Structure

### 1. `backend.yml` - Backend CI/CD
**Triggers:** Changes to `backend/**` or workflow file

**Jobs:**
- **test**: Run Python linting (ruff), tests (pytest), type checking (mypy)
- **build**: Build Docker image and push to GHCR
- **deploy-dev**: Auto-deploy to dev environment on `develop` branch
- **deploy-prod**: Auto-deploy to prod environment on `main` branch (requires approval)

**Image Tags:**
- `ghcr.io/learnmv/learnwithai/backend:latest` (main branch)
- `ghcr.io/learnmv/learnwithai/backend:develop` (develop branch)
- `ghcr.io/learnmv/learnwithai/backend:sha-xxx` (commit SHA)

### 2. `frontend.yml` - Frontend CI/CD
**Triggers:** Changes to `frontend/**` or workflow file

**Jobs:**
- **lint-and-build**: ESLint, TypeScript check, build Vue app
- **build-docker**: Build nginx Docker image and push to GHCR
- **deploy-static**: Deploy to GitHub Pages or K8s

**Image Tags:**
- `ghcr.io/learnmv/learnwithai/frontend:latest`
- `ghcr.io/learnmv/learnwithai/frontend:develop`

### 3. `deploy.yml` - Manual Deployment
**Trigger:** Manual workflow dispatch

**Use Cases:**
- Rollback to previous version
- Deploy specific image tag
- Deploy individual services

**Inputs:**
- Environment (development/production)
- Image tag
- Service (backend/frontend/all)

### 4. `pr-checks.yml` - PR Validation
**Triggers:** Pull requests to main/develop

**Jobs:**
- Detect changed files
- Run backend lint/security checks
- Run frontend lint/build
- Build Docker images (no push)
- Post status comment on PR

## Setup Instructions

### 1. Enable GitHub Container Registry

1. Go to **Package settings** in your repository
2. Under **Manage Actions access**, ensure workflows have write access
3. Or run manually first:
```bash
# Create a Personal Access Token with write:packages scope
# Then login and push initial image
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### 2. Configure KUBECONFIG Secret

1. Get your kubeconfig file:
```bash
cat ~/.kube/config | base64 -w 0
```

2. Add as GitHub Secret:
- Go to **Settings → Secrets and variables → Actions**
- Create secret named `KUBECONFIG`
- Paste the base64-encoded kubeconfig

### 3. GitHub Environments (Optional but Recommended)

Create two environments for protection rules:

**Development Environment:**
- Go to **Settings → Environments → New environment**
- Name: `development`
- No protection rules needed for dev

**Production Environment:**
- Go to **Settings → Environments → New environment**
- Name: `production`
- Enable **Required reviewers** (add yourself/team)
- Enable **Wait timer** (e.g., 5 minutes)
- Add deployment branch protection

## How It Works

### Developer Workflow

1. **Create feature branch** from `develop`:
```bash
git checkout -b feature/my-feature develop
```

2. **Make changes** to frontend or backend

3. **Push and create PR**:
```bash
git push origin feature/my-feature
# Create PR to develop branch
```

4. **PR Checks** run automatically:
   - Lint checks
   - Type checking
   - Build verification
   - Security scans

5. **Merge to develop** → Auto-deploys to dev environment

6. **Create PR to main** → After review, merge deploys to prod

### Deployment Flow

```
Push to branch
    ↓
GitHub Actions triggers
    ↓
Run tests/lint/build
    ↓
Build Docker image
    ↓
Push to GHCR
    ↓
Update K8s deployment
    ↓
Rolling update with health checks
```

## Manual Deployment

### Deploy Specific Version

1. Go to **Actions → Manual Deploy → Run workflow**

2. Fill parameters:
   - **Environment**: `production`
   - **Image tag**: `sha-abc123` (from previous build)
   - **Service**: `backend` or `all`

3. Click **Run workflow**

### Rollback

If deployment fails, workflow automatically rolls back:
```bash
kubectl rollout undo deployment/backend -n learnwithai-prod
```

Or use manual deploy with previous image tag.

## Image Registry

View all images at:
https://github.com/learnmv/learnwithai/pkgs/container/learnwithai%2Fbackend
https://github.com/learnmv/learnwithai/pkgs/container/learnwithai%2Ffrontend

### Pull Images Locally

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Pull images
docker pull ghcr.io/learnmv/learnwithai/backend:latest
docker pull ghcr.io/learnmv/learnwithai/frontend:latest
```

## Troubleshooting

### Workflow Not Triggering
- Check branch names match (main/develop)
- Verify file paths in `paths:` filter
- Check if workflow is disabled in Actions tab

### Image Push Fails
- Verify `GITHUB_TOKEN` has `write:packages` permission
- Check repository Package settings
- Ensure image name matches repository name format

### K8s Deploy Fails
- Verify `KUBECONFIG` secret is set correctly
- Check if kubectl can connect: `kubectl cluster-info`
- Verify namespace exists: `kubectl get ns`

### Build Cache Not Working
- Enable GitHub Actions cache in repository settings
- Check `cache-from` and `cache-to` in workflow

## Security Best Practices

1. **Never commit secrets** - Use GitHub Secrets
2. **Use minimal permissions** - GITHUB_TOKEN only has required scopes
3. **Scan images** - Trivy/Anchore scanning (add to workflows)
4. **Sign images** - Use cosign for image signing (optional)
5. **Pin actions** - Use specific commit SHAs for actions (not latest)

## Cost Optimization

GitHub Actions free tier:
- 2,000 minutes/month for public repos
- 500 MB storage for packages

To reduce usage:
- Use `paths:` filter to only run on relevant changes
- Use Docker layer caching
- Cancel outdated workflow runs
- Use self-hosted runners for larger workloads

## Future Enhancements

- [ ] Add Trivy image scanning
- [ ] Add smoke tests after deployment
- [ ] Implement blue/green deployments
- [ ] Add notification to Slack/Discord
- [ ] Add performance benchmarks
- [ ] Implement automated rollback on failed health checks
- [ ] Add DAST security scanning
