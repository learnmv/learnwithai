#!/bin/bash

# LearnWithAI Kubernetes Deployment Script
# Usage: ./deploy.sh [dev|prod]

set -e

ENVIRONMENT=${1:-dev}
NAMESPACE="learnwithai-${ENVIRONMENT}"

echo "🌱 LearnWithAI Deployment Script"
echo "================================="
echo ""

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

# Check if kubernetes cluster is running
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Kubernetes cluster not accessible. Please check your cluster."
    exit 1
fi

echo "✓ Kubernetes cluster accessible"

# Function to deploy development environment
deploy_dev() {
    echo ""
    echo "🚀 Deploying DEVELOPMENT environment..."
    echo ""

    # Build backend image
    echo "Building backend Docker image..."
    cd "$(dirname "$0")/../backend"
    docker build -t learnwithai-backend:latest .

    # Load image if using kind
    if kubectl get nodes -o jsonpath='{.items[0].metadata.name}' | grep -q "kind-"; then
        echo "Loading image into kind cluster..."
        kind load docker-image learnwithai-backend:latest
    fi

    # Apply manifests
    echo "Applying Kubernetes manifests..."
    kubectl apply -f "$(dirname "$0")/dev.yml"

    # Wait for pods
    echo ""
    echo "⏳ Waiting for pods to be ready..."
    kubectl wait --namespace ${NAMESPACE} --for=condition=ready pod --selector app=postgres --timeout=120s || true
    kubectl wait --namespace ${NAMESPACE} --for=condition=ready pod --selector app=ollama --timeout=300s || true
    kubectl wait --namespace ${NAMESPACE} --for=condition=ready pod --selector app=backend --timeout=60s || true

    # Show status
    echo ""
    echo "📊 Deployment Status:"
    kubectl get pods -n ${NAMESPACE}

    echo ""
    echo "✅ Development deployment complete!"
    echo ""
    echo "Access points:"
    echo "  • API Docs: http://localhost:30080/docs"
    echo "  • PostgreSQL: localhost:30432"
    echo "  • Ollama: localhost:30434"
    echo ""
}

# Function to deploy production environment
deploy_prod() {
    echo ""
    echo "🚀 Deploying PRODUCTION environment..."
    echo ""

    # Check if required secrets are set
    echo "⚠️  IMPORTANT: Please ensure you have updated the secrets in prod.yml"
    echo "   - postgres-secret password"
    echo "   - backend-secret secret-key"
    echo ""
    read -p "Have you updated the secrets? (yes/no): " confirm

    if [ "$confirm" != "yes" ]; then
        echo "❌ Deployment cancelled. Please update secrets first."
        exit 1
    fi

    # Build and push production image
    echo "Building production Docker image..."
    cd "$(dirname "$0")/../backend"

    # Get registry from user
    read -p "Enter your Docker registry (e.g., docker.io/username): " registry

    docker build -t ${registry}/learnwithai-backend:v1.0.0 .

    echo "Pushing image to registry..."
    docker push ${registry}/learnwithai-backend:v1.0.0

    # Update image in prod.yml
    sed -i.bak "s|learnwithai-backend:latest|${registry}/learnwithai-backend:v1.0.0|g" "$(dirname "$0")/prod.yml"

    # Apply manifests
    echo "Applying Kubernetes manifests..."
    kubectl apply -f "$(dirname "$0")/prod.yml"

    # Wait for rollout
    echo ""
    echo "⏳ Waiting for rollout to complete..."
    kubectl rollout status deployment/backend -n ${NAMESPACE} --timeout=300s

    # Show status
    echo ""
    echo "📊 Production Deployment Status:"
    kubectl get pods -n ${NAMESPACE}
    kubectl get svc -n ${NAMESPACE}
    kubectl get ingress -n ${NAMESPACE}

    echo ""
    echo "✅ Production deployment complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Configure DNS to point to your ingress IP"
    echo "  2. Set up TLS certificates"
    echo "  3. Configure monitoring and logging"
    echo ""
}

# Function to show help
show_help() {
    echo "Usage: $0 [dev|prod|destroy-dev|destroy-prod|status]"
    echo ""
    echo "Commands:"
    echo "  dev          Deploy development environment"
    echo "  prod         Deploy production environment"
    echo "  destroy-dev  Remove development environment"
    echo "  destroy-prod Remove production environment"
    echo "  status       Show deployment status"
    echo "  help         Show this help message"
    echo ""
}

# Function to show status
show_status() {
    echo ""
    echo "📊 Deployment Status"
    echo "=================="
    echo ""

    for env in dev prod; do
        ns="learnwithai-${env}"
        if kubectl get namespace ${ns} &> /dev/null; then
            echo "Environment: ${env}"
            echo "-------------------"
            kubectl get pods -n ${ns}
            kubectl get svc -n ${ns}
            echo ""
        else
            echo "Environment ${env}: Not deployed"
            echo ""
        fi
    done
}

# Function to destroy environment
destroy_environment() {
    env=$1
    ns="learnwithai-${env}"

    echo ""
    echo "⚠️  WARNING: This will DELETE all resources in ${env} environment!"
    read -p "Are you sure you want to proceed? (yes/no): " confirm

    if [ "$confirm" != "yes" ]; then
        echo "❌ Destruction cancelled."
        exit 1
    fi

    echo ""
    echo "🗑️  Deleting ${env} environment..."
    kubectl delete namespace ${ns}

    echo ""
    echo "✅ ${env} environment deleted."
}

# Main script logic
case ${ENVIRONMENT} in
    dev)
        deploy_dev
        ;;
    prod)
        deploy_prod
        ;;
    destroy-dev)
        destroy_environment "dev"
        ;;
    destroy-prod)
        destroy_environment "prod"
        ;;
    status)
        show_status
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: ${ENVIRONMENT}"
        show_help
        exit 1
        ;;
esac
