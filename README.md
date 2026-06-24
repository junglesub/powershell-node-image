# powershell-node-image

PowerShell 7.4 Ubuntu 22.04 base image with Node.js 24 installed.

## Image

- Repository: `junglesub/powershell-node-image`
- Base image: `mcr.microsoft.com/powershell:7.4-ubuntu-22.04`
- Published image: `ghcr.io/junglesub/powershell-node-image:pwsh7.4-node24`
- Extra immutable tag: `ghcr.io/junglesub/powershell-node-image:<commit-sha>`
- Platforms: `linux/amd64`, `linux/arm64`

The GitHub Actions workflow derives the GHCR owner from built-in GitHub variables and publishes with the repository image name, so no repository URL or custom secret is required.

## Publish

The workflow is defined in `.github/workflows/publish-powershell-node.yml`.

It publishes when:

- Manually run with `workflow_dispatch`
- Pushed to `main` with changes to `Dockerfile`, `Dockerfile.arm64`, or the workflow file

Required repository setting:

- `Settings > Actions > General > Workflow permissions`: enable read/write permissions, or keep the workflow `packages: write` permission available for `GITHUB_TOKEN`.

## Contents

The amd64 Dockerfile starts from `mcr.microsoft.com/powershell:7.4-ubuntu-22.04`, installs Node.js from the official Node.js Linux x64 tarball, and verifies the downloaded archive with `SHASUMS256.txt`. It also keeps `libc6` installed so the official Node.js binaries have the glibc dynamic loader they need.

The arm64 Dockerfile starts from `ubuntu:22.04`, installs PowerShell 7.4 from the official PowerShell Linux arm64 tarball, then installs Node.js from the official Node.js Linux arm64 tarball.

The default build arguments are:

```text
NODE_VERSION=24.0.0
POWERSHELL_VERSION=7.4.6
```

GitHub Actions passes these build arguments through the workflow environment variables.

## Architecture

The workflow builds architecture-specific images in parallel with a matrix:

- `linux/amd64`: uses `Dockerfile` and the requested `mcr.microsoft.com/powershell:7.4-ubuntu-22.04` base image.
- `linux/arm64`: uses `Dockerfile.arm64` because the selected MCR PowerShell tag currently resolves as a single `linux/amd64` manifest. Reusing it for ARM64 installs an ARM64 Node.js tarball into an amd64 rootfs and fails with a missing `/lib/ld-linux-aarch64.so.1` loader.

After both architecture images are pushed with temporary suffix tags, the publish job creates the final multi-arch GHCR manifest tags:

- `ghcr.io/junglesub/powershell-node-image:pwsh7.4-node24`
- `ghcr.io/junglesub/powershell-node-image:<commit-sha>`

## Local Note

This repository does not require local package installation for publishing. Local Docker builds are intentionally not part of the default workflow here; image creation is performed by GitHub Actions.
