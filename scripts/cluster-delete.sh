#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="infra"
REGISTRY_NAME="k3d-${CLUSTER_NAME}-registry"

echo "Deleting k3d cluster and registry..."
echo ""

read -p "Are you sure? This will delete the cluster '$CLUSTER_NAME' (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cancelled"
  exit 0
fi

if k3d cluster list | grep -q "^$CLUSTER_NAME"; then
  echo "Deleting cluster: $CLUSTER_NAME"
  k3d cluster delete "$CLUSTER_NAME"
fi

if docker ps -a --format '{{.Names}}' | grep -q "^$REGISTRY_NAME$"; then
  echo "Removing registry alias: $REGISTRY_NAME"
  docker rm -f "$REGISTRY_NAME" 2>/dev/null || true
fi

echo ""
echo "Cleanup complete"
