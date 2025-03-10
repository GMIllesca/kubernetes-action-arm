FROM alpine@sha256:757d680068d77be46fd1ea20fb21db16f150468c5e7079a08a2e4705aec096ac

# Install minimal dependencies
RUN apk add --no-cache \
    bash \
    curl \
    ca-certificates

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"] 