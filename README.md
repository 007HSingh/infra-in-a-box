# infra-in-a-box

Local, zero-cost developer infra stack (k3d + local registry + Argo CD + Nix dev shell).
This repo aims to provide a reproducible dev environment and CI/CD flow using local tools.

## Quick layout

- `nix/` - Nix flakes and devShell
- `local-infra/` - docker-compose, local scripts, registry
- `k8s/` - base manifests, argocd, helm charts
- `apps/` - sample apps (springboot, rustsvc)
- `scripts/` - orchestration helpers
- `docs/` - architecture diagrams and guides
