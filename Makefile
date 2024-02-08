SHELL := /bin/bash
BRANCH_NAME ?= $(shell git branch | grep \* | cut -d ' ' -f2)
PROJECT_NAME ?= machine-learning-environments
GIT_COMMIT ?= $(shell git rev-parse HEAD)
PYTHON_INTERPRETER = python3
PYTHON_VERSION ?= 3.11
OS_NAME = $(shell uname)
REGISTRY_URL ?= nielsborie

ifeq ($(BRANCH_NAME),main)
	IMAGE_VERSION := v$(shell cat ./VERSION.txt)
else ifeq ($(BRANCH_NAME),develop)
	IMAGE_VERSION := v$(shell cat ./SNAPSHOT.txt)
else
	IMAGE_VERSION := -$(BRANCH_NAME)
endif
DOCKER_TAG_NAME := ${LAYER}-py${PYTHON_VERSION}-${IMAGE_VERSION}

SUPPORTED_PYTHON_VERSIONS := 3.9 3.10 3.11 3.12
ALL_LAYERS := base advanced

.DEFAULT_GOAL:=help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

### Docker ###
.PHONY: build-all-images build-image

build-all-images: ## Build all machine-learning-environments docker images
	@for version in $(SUPPORTED_PYTHON_VERSIONS); do \
		for layer in $(ALL_LAYERS); do \
			$(MAKE) build-image PYTHON_VERSION=$$version LAYER=$$layer IMAGE_VERSION=$(IMAGE_VERSION); \
		done \
	done

build-image: ## Build a single machine-learning-environments docker image (args : PYTHON_VERSION, LAYER, IMAGE_VERSION)
	@echo "PYTHON_VERSION=$(PYTHON_VERSION) PYTHON_RELEASE_VERSION=$$(jq -r '.python."$(PYTHON_VERSION)".release' package.json)"
	@real_python_version=$$(jq -r '.python."$(PYTHON_VERSION)".release' package.json); \
	docker build --progress=plain --no-cache --force-rm -t $(REGISTRY_URL)/$(PROJECT_NAME):$${LAYER}-py$(PYTHON_VERSION)-$(IMAGE_VERSION) --build-arg PYTHON_RELEASE_VERSION=$$real_python_version --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --build-arg IMAGE_VERSION=$(IMAGE_VERSION) $(LAYER)/.


docker-push: ## Push machine-learning-environments image to registry
	docker push ${REGISTRY_URL}/${PROJECT_NAME}:${DOCKER_TAG_NAME}
	if [ "${BRANCH_NAME}" = "main" ]; then \
        docker push ${REGISTRY_URL}/${PROJECT_NAME}:latest; \
    fi;

### Running environments ###
docker-run: ## Run machine-learning-environments using docker image
	docker run --name ML-env -d $(REGISTRY_URL)/$(PROJECT_NAME):$${LAYER}-py$(PYTHON_VERSION)-$(IMAGE_VERSION) /bin/bash

docker-interactive:
	docker exec -it ML-env bin/bash

start: ## Start the machine-learning-environments container
	docker start ML-env

stop: ## Stop the machine-learning-environments container
	docker stop ML-env

clean: ## Remove the machine-learning-environments container
	docker rm ML-env

### RELEASE ###
generate-changelog: ## Generate/Update CHANGELOG.md file
	gitmoji-changelog

### GitHub action test ###
test_github_actions:
	act --job create_release --eventpath tests/resources/trigger-release.event