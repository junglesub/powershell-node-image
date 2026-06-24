# powershell-node-image

PowerShell 7.4 Ubuntu 22.04 base image with Node.js 24 installed.

## Image

- Base image: `mcr.microsoft.com/powershell:7.4-ubuntu-22.04`
- Published image: `ghcr.io/<github-owner>/powershell-node:pwsh7.4-node24`
- Extra immutable tag: `ghcr.io/<github-owner>/powershell-node:<commit-sha>`
- Platforms: `linux/amd64`

The GitHub Actions workflow derives the GHCR owner from built-in GitHub variables, so no repository URL or custom secret is required.

## Publish

The workflow is defined in `.github/workflows/publish-powershell-node.yml`.

It publishes when:

- Manually run with `workflow_dispatch`
- Pushed to `main` with changes to `Dockerfile` or the workflow file

Required repository setting:

- `Settings > Actions > General > Workflow permissions`: enable read/write permissions, or keep the workflow `packages: write` permission available for `GITHUB_TOKEN`.

## Contents

The Dockerfile installs Node.js from the official Node.js Linux tarball and verifies the downloaded archive with `SHASUMS256.txt`. It also keeps `libc6` installed so the official Node.js binaries have the glibc dynamic loader they need. The default build argument is:

```text
NODE_VERSION=24.0.0
```

GitHub Actions passes this build argument through the workflow `NODE_VERSION` environment variable.

## Architecture

This workflow publishes `linux/amd64`. The selected base image, `mcr.microsoft.com/powershell:7.4-ubuntu-22.04`, resolves to an amd64 Ubuntu rootfs in the GitHub Actions build. Building it as `linux/arm64` installs an ARM64 Node.js tarball into that amd64 rootfs, which fails at runtime with a missing `/lib/ld-linux-aarch64.so.1` loader.

## Local Note

This repository does not require local package installation for publishing. Local Docker builds are intentionally not part of the default workflow here; image creation is performed by GitHub Actions.
