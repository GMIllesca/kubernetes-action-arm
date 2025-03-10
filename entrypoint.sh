#!/bin/bash

# Decode KUBE_CONFIG_DATA if provided
if [ -n "$KUBE_CONFIG_DATA" ]; then
    echo "$KUBE_CONFIG_DATA" | base64 -d > /tmp/kubeconfig
    export KUBECONFIG=/tmp/kubeconfig
fi

# Run kubectl command
kubectl $@

# Clean up
rm -f /tmp/kubeconfig 