#!/bin/sh
set -e

# Debug information
echo "Container Architecture: $(uname -m)"
echo "Container OS: $(uname -a)"
echo "Container OS Release: $(cat /etc/os-release)"

# Decode KUBE_CONFIG_DATA if provided
if [ -n "$KUBE_CONFIG_DATA" ]; then
    echo "Setting up kubectl configuration..."
    echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/kubeconfig
    export KUBECONFIG=/tmp/kubeconfig
fi

# Verify kubectl installation
if ! command -v kubectl >/dev/null 2>&1; then
    echo "Error: kubectl is not installed or not in PATH"
    exit 1
fi

# Run kubectl command with debug
echo "Running: kubectl $@"
kubectl $@

# Clean up
if [ -f "/tmp/kubeconfig" ]; then
    rm /tmp/kubeconfig
fi 