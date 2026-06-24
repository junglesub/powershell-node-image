FROM mcr.microsoft.com/powershell:7.4-ubuntu-22.04

ARG NODE_VERSION=24.0.0
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) node_arch="x64" ;; \
      arm64) node_arch="arm64" ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${node_arch}.tar.xz"; \
    curl -fsSLO "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt"; \
    grep " node-v${NODE_VERSION}-linux-${node_arch}.tar.xz\$" SHASUMS256.txt | sha256sum -c -; \
    tar -xJf "node-v${NODE_VERSION}-linux-${node_arch}.tar.xz" -C /usr/local --strip-components=1; \
    rm "node-v${NODE_VERSION}-linux-${node_arch}.tar.xz" SHASUMS256.txt; \
    apt-get purge -y --auto-remove curl xz-utils; \
    rm -rf /var/lib/apt/lists/*

RUN pwsh -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion.ToString()' \
    && node --version \
    && npm --version \
    && corepack --version
