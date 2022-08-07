SHELL := /bin/bash
BRANCH_NAME ?= $(shell git branch | grep \* | cut -d ' ' -f2)
PROJECT_NAME ?= machine-learning-environments
GIT_COMMIT ?= $(shell git rev-parse HEAD)

REGISTRY_URL ?= nielsborie
DOCKER_TAG_NAME = $(BRANCH_NAME)
export REGISTRY_URL

.DEFAULT_GOAL:=help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

docker-build: ## Build machine-learning-environments docker image
	docker build --force-rm -t ${REGISTRY_URL}/${PROJECT_NAME}:${DOCKER_TAG_NAME} .
	docker tag ${REGISTRY_URL}/${PROJECT_NAME}:${DOCKER_TAG_NAME} ${REGISTRY_URL}/${PROJECT_NAME}:latest

docker-push: ## Push machine-learning-environments image to registry
	docker push ${REGISTRY_URL}/${PROJECT_NAME}:${DOCKER_TAG_NAME}
	if [ "${BRANCH_NAME}" = "main" ]; then \
        docker push ${REGISTRY_URL}/${PROJECT_NAME}:latest; \
    fi;

docker-run: ## Run machine-learning-environments using docker image
	docker run --name ML-env -d -p 8887:8888 ${REGISTRY_URL}/${PROJECT_NAME}:latest

start: ## Start the machine-learning-environments container
	docker start ML-env

stop: ## Stop the machine-learning-environments container
	docker start ML-env