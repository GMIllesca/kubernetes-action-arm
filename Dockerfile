FROM debian:bullseye-slim

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for buildkit
ENV DOCKER_BUILDKIT=1
ENV BUILDKIT_PROGRESS=plain

# Debug information
RUN echo "Architecture: $(uname -m)" && \
    echo "OS: $(uname -a)" && \
    cat /etc/os-release

# Update package list
RUN set -x && \
    apt-get update

# Install certificates first
RUN set -x && \
    apt-get install -y --no-install-recommends ca-certificates && \
    apt-get clean

# Install curl
RUN set -x && \
    apt-get install -y --no-install-recommends curl && \
    apt-get clean

# Install Python
RUN set -x && \
    apt-get install -y --no-install-recommends \
    python3-minimal \
    python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    python3 --version && \
    pip3 --version

# Install AWS CLI with debug
RUN set -x && \
    pip3 install --no-cache-dir --verbose \
    awscli \
    setuptools \
    wheel

# Install kubectl directly from binary
COPY --chmod=755 <<EOF /usr/local/bin/install-kubectl.sh
#!/bin/sh
set -e
ARCH=\$(dpkg --print-architecture)
curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/\${ARCH}/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/
EOF

RUN /usr/local/bin/install-kubectl.sh && \
    rm /usr/local/bin/install-kubectl.sh

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"] 