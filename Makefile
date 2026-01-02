.PHONY: dev check-tools clean help

help:
	@echo "infra-in-a-box Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make dev          - Enter Nix dev shell"
	@echo "  make check-tools  - Verify all tools are available"
	@echo "  make clean        - Clean build artifacts"
	@echo ""
	@echo "Infrastructure:"
	@echo "  make cluster-up     - Create k3d cluster with registry"
	@echo "  make cluster-status - Show cluster status"
	@echo "  make cluster-down   - Delete k3d cluster and registry"
	@echo ""
	@echo "Cleanup:"
	@echo "  make clean         - Clean build artifacts"

dev:
	nix develop

check-tools:
	@docker --version
	@kubectl version --client
	@k3d version
	@helm version
	@java --version
	@gradle --version
	@cargo --version

cluster-up:
	@./scripts/setup-k3d.sh

cluster-status:
	@./scripts/cluster-status.sh

cluster-down:
	@./scripts/cluster-delete.sh

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf apps/*/build apps/*/target 
	@echo "Clean complete"
