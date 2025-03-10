FROM debian:bullseye-slim

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

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

# Download and install kubectl with debug
RUN set -x && \
    ARCH=$(uname -m) && \
    echo "Detected architecture: ${ARCH}" && \
    case ${ARCH} in \
        x86_64) ARCH="amd64" ;; \
        aarch64) ARCH="arm64" ;; \
        *) echo "Unsupported architecture: ${ARCH}" && exit 1 ;; \
    esac && \
    echo "Kubectl architecture to use: ${ARCH}" && \
    curl -v -LO "https://storage.googleapis.com/kubernetes-release/release/v1.28.4/bin/linux/${ARCH}/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"] 