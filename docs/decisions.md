# Project Decisions (Local-only)

- Kubernetes: k3d (k3s inside Docker)
- Registry: local Docker registry (registry:2)
- GitOps: Argo CD
- Secrets: SealedSecrets (local keypair)
- Apps:
  - Spring Boot (Kotlin)
  - Rust (axum)
- Infrastructure: scripts + Makefile (Terraform optional)

Reason: zero-cost, reproducible, production-like learning.
