.PHONY: help
help:
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
SCRIPTS_DIR := $(shell git rev-parse --show-toplevel)/dev
SCANNER ?= trivy
TAG ?= test

.PHONY: build
build: deps clean ## Build the Docker image with TAG
	@bash $(SCRIPTS_DIR)/build.sh --tag $(TAG) --local

.PHONY: check
check: ## Run linters and other code quality checks
	@bash $(SCRIPTS_DIR)/check.sh

.PHONY: clean
clean: ## Clean up resources (containers, builders, etc.)
	@if [ "$(MAKECMDGOALS)" = "clean" ]; then \
		bash $(SCRIPTS_DIR)/clean.sh; \
	else \
		bash $(SCRIPTS_DIR)/clean.sh > /dev/null 2>&1; \
	fi

.PHONY: deps
deps: ## Verify dependencies (e.g. Docker, buildx, uv)
	@if [ "$(MAKECMDGOALS)" = "deps" ]; then \
		bash $(SCRIPTS_DIR)/deps.sh; \
	else \
		bash $(SCRIPTS_DIR)/deps.sh > /dev/null; \
	fi

.PHONY: fix
fix: ## Run linters and other code quality checks in fix mode
	@bash $(SCRIPTS_DIR)/check.sh --fix

.PHONY: publish
publish: deps clean ## Build and push the Docker image with TAG
	@bash $(SCRIPTS_DIR)/build.sh --tag $(TAG) --push

.PHONY: run
run: deps clean ## Run the Docker image locally
	@bash $(SCRIPTS_DIR)/run.sh --tag $(TAG)

.PHONY: scan
scan: deps clean build ## Scan the Docker image with TAG for vulnerabilities
	@bash $(SCRIPTS_DIR)/scan.sh --tag $(TAG) --scanner $(SCANNER)
