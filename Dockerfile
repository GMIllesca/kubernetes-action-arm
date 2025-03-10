FROM alpine:3.18

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    ca-certificates \
    bash

# Install AWS CLI and other Python packages
RUN pip3 install --no-cache-dir \
    awscli \
    setuptools \
    wheel

# Install kubectl
RUN ARCH=$(case $(uname -m) in x86_64) echo "amd64" ;; aarch64) echo "arm64" ;; *) echo "amd64" ;; esac) && \
    curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/${ARCH}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"] 