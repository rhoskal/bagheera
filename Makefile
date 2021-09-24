# Build configuration
# -------------------

APP_NAME = `grep -Eo 'app: :\w*' mix.exs | cut -d ':' -f 3`
GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
GIT_REVISION = `git rev-parse HEAD`

# Introspection targets
# ---------------------

.PHONY: help
help: header targets

.PHONY: header
header:
	@echo "\033[34mEnvironment\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@printf "\033[33m%-23s\033[0m" "APP_NAME"
	@printf "\033[35m%s\033[0m" $(APP_NAME)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "GIT_BRANCH"
	@printf "\033[35m%s\033[0m" $(GIT_BRANCH)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "GIT_REVISION"
	@printf "\033[35m%s\033[0m" $(GIT_REVISION)
	@echo "\n"

.PHONY: targets
targets:
	@echo "\033[34mTargets\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

# Build targets
# -------------

.PHONY: build
build: ## Make a production build
	MIX_ENV=prod mix release

# Development targets
# -------------------

.PHONY: clean
clean: ## Remove build artifacts
	rm -rf _build

.PHONE: deps
deps: ## Install dependencies
	mix deps.get --force

.PHONY: run
run: ## Run the api server
	iex -S mix phx.server

.PHONY: test
test: ## Test code
	mix test

# Check, lint and format targets
# ------------------------------

.PHONY: format
format: format-ex ## Format all the files

.PHONY: format-ex
format-ex:
	mix format

.PHONY: lint
lint: lint-ex ## Lint all the files

.PHONY: lint-ex
lint-ex:
	mix credo --strict
