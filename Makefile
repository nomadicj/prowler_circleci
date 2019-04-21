# use some sensible default shell settings
SHELL := /bin/bash
.SILENT:

# default variables
TIER ?= capabilities
CAPABILITY ?= testing
ENV ?= dummy
REGION ?= au

# available options, use regex to string check
RE_TIER = ^(core|capabilities)$$
RE_CAPABILITY = ^(lending|wealth|super|marketdata|trading|platform|digital|sourcing|sharedservices|auth|tech|testing|workload)$$
RE_ENV = ^(dummy|development|staging|uat|production)$$
RE_REGION = ^(au|uk|za|ca|sg|us)$$

# docker-compose calls
PROWLER = docker-compose run prowler

export COMPOSE_PROJECT_NAME = secops_$(TIER)_$(CAPABILITY)_$(ENV)_$(REGION)

##@ Entry Points
.PHONY: all
all: prowler ## Execute all SecOps functions against account provided

.PHONY: prowler
prowler: _clean ## Execute prowler CIS check against account provided
	$(PROWLER) ./prowler || true

.PHONY: _clean
_clean:
	docker network prune -f || true

.PHONY: help
help: ## Display this help
	awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
