.PHONY: dev check-tools clean help

help:
	@echo "infra-in-a-box Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make dev          - Enter Nix dev shell"
	@echo "  make check-tools  - Verify all tools are available"
	@echo "  make clean        - Clean build artifacts"

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

clean:
	@rm -rf apps/*/build apps/*/target 
