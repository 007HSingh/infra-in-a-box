#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

CLUSTER_NAME="infra"
REGISTRY_NAME="k3d-${CLUSTER_NAME}-registry"
REGISTRY_PORT="5000"

echo "Setting up k3d cluster: $CLUSTER_NAME"
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Please start Docker first."
  exit 1
fi

# Check if cluster already exists
if k3d cluster list | grep -q "^$CLUSTER_NAME"; then
  echo "Cluster '$CLUSTER_NAME' already exists"
  read -p "Delete and recreate? (y/N): " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Deleting existing cluster..."
    k3d cluster delete "$CLUSTER_NAME"
  else
    echo "Using existing cluster"
    exit 0
  fi
fi

# Create k3d-managed registry if it doesn't exist
if ! docker ps --format '{{.Names}}' | grep -q "^$REGISTRY_NAME$"; then
  echo "Creating k3d-managed registry..."
  k3d registry create "${CLUSTER_NAME}-registry" --port ${REGISTRY_PORT}
else
  echo "Registry '$REGISTRY_NAME' already exists"
fi

echo "Creating k3d cluster..."
k3d cluster create "$CLUSTER_NAME" \
  --config "$PROJECT_ROOT/local-infra/k3d/cluster-config.yaml" \
  --registry-use "${REGISTRY_NAME}:${REGISTRY_PORT}"

echo ""
echo "Waiting for cluster to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

echo ""
echo "k3d cluster '$CLUSTER_NAME' is ready!"
echo ""
echo "Cluster info:"
kubectl cluster-info
echo ""
echo "Nodes:"
kubectl get nodes -o wide
echo ""
echo "Registry:"
echo "   Push images to: localhost:${REGISTRY_PORT}/your-image:tag"
echo "   From cluster: ${REGISTRY_NAME}:${REGISTRY_PORT}/your-image:tag"
echo ""
echo "Quick commands:"
echo "   kubectl get nodes        - List nodes"
echo "   kubectl get pods -A      - List all pods"
echo "   k3d cluster stop infra   - Stop cluster"
echo "   k3d cluster start infra  - Start cluster"
echo "   k3d cluster delete infra - Delete cluster"
echo ""
echo "Note: The registry is managed by k3d and will persist across cluster restarts"
