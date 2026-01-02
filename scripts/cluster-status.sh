#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="infra"

echo "Cluster Status: $CLUSTER_NAME"
echo ""

if ! k3d cluster list | grep -q "^$CLUSTER_NAME"; then
  echo "Cluster '$CLUSTER_NAME' does not exist"
  echo ""
  echo "Create it with: ./scripts/setup-k3d.sh"
  exit 1
fi

echo "k3d cluster:"
k3d cluster list | grep "$CLUSTER_NAME"
echo ""

echo "Nodes:"
kubectl get nodes -o wide
echo ""

echo "System Pods:"
kubectl get pods -n kube-system
echo ""

echo "Resource Usage:"
kubectl top nodes 2>/dev/null || echo "   (metrics-server not yet installed)"
