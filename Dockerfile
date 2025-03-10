FROM python:3.9-slim

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN pip3 install --no-cache-dir \
    awscli \
    setuptools \
    wheel

# Install kubectl
RUN arch=$(dpkg --print-architecture) && \
    case ${arch} in \
        "arm64") arch="arm64" ;; \
        "amd64") arch="amd64" ;; \
        *) echo "Unsupported architecture: ${arch}" && exit 1 ;; \
    esac && \
    curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/${arch}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"] 