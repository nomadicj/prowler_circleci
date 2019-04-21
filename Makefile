# use some sensible default shell settings
SHELL := /bin/bash
.SILENT:

# docker-compose calls
PROWLER = docker-compose run prowler

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
