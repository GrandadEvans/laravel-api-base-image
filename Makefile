.PHONY: help ps build build-prod start fresh fresh-prod stop restart destroy \
	cache cache-clear migrate migrate migrate-fresh tests tests-html

CONTAINER_PHP=api
CONTAINER_REDIS=redis
CONTAINER_DATABASE=database

help: ## Print help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

auth: ## Authenticate with AWS
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 636578990471.dkr.ecr.eu-west-2.amazonaws.com
build: ## Build the production image
	docker build -t prod-laravel-api-base-image .

build-push: ## Build & Push
	make build
	make push

push: ## Push the Production image
	docker tag prod-laravel-api-base-image:latest 636578990471.dkr.ecr.eu-west-2.amazonaws.com/prod-laravel-api-base-image:latest
	docker push 636578990471.dkr.ecr.eu-west-2.amazonaws.com/prod-laravel-api-base-image:latest
