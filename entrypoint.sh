#!/bin/bash
set -e

# Decode KUBE_CONFIG_DATA
if [ -n "$KUBE_CONFIG_DATA" ]; then
  echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/kubeconfig
  export KUBECONFIG=/tmp/kubeconfig
fi

# Run kubectl command
echo "Running: kubectl $@"
kubectl $@

# Clean up
if [ -f "/tmp/kubeconfig" ]; then
  rm /tmp/kubeconfig
fi 