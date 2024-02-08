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
ALL_BUILDERS := conda mamba

LAYER ?= base
BUILDER ?= conda

.DEFAULT_GOAL:=help

help:  ## Display this help
	@echo "Usage:"
	@echo "  make <target>"
	@echo ""
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

### Docker ###
.PHONY: build-all-images build-image

build-all-images: ## Build all machine-learning-environments docker images
	@for version in $(SUPPORTED_PYTHON_VERSIONS); do \
		for layer in $(ALL_LAYERS); do \
			$(MAKE) build-image PYTHON_VERSION=$$version LAYER=$$layer IMAGE_VERSION=$(IMAGE_VERSION); \
		done \
	done

build-image: ## Build a single machine-learning-environments docker image (args : PYTHON_VERSION, LAYER, BUILDER, IMAGE_VERSION)
	@echo "PYTHON_VERSION=$(PYTHON_VERSION) PYTHON_RELEASE_VERSION=$$(jq -r '.python."$(PYTHON_VERSION)".release' package.json)"
	@real_python_version=$$(jq -r '.python."$(PYTHON_VERSION)".release' package.json); \
	docker build --progress=plain --no-cache --force-rm -t $(REGISTRY_URL)/$(PROJECT_NAME):$${LAYER}-$(BUILDER)-py$(PYTHON_VERSION)-$(IMAGE_VERSION) --build-arg PYTHON_RELEASE_VERSION=$$real_python_version --build-arg PYTHON_VERSION=$(PYTHON_VERSION) --build-arg IMAGE_VERSION=$(IMAGE_VERSION) --build-arg BUILDER=$(BUILDER) -f layers/$(LAYER)/$(BUILDER).Dockerfile layers/$(LAYER)/


docker-push: ## Push machine-learning-environments image to registry
	docker push ${REGISTRY_URL}/${PROJECT_NAME}:${DOCKER_TAG_NAME}
	if [ "${BRANCH_NAME}" = "main" ]; then \
        docker push ${REGISTRY_URL}/${PROJECT_NAME}:latest; \
    fi;

### Running environments ###
docker-run: ## Run machine-learning-environments using docker image  (args : PYTHON_VERSION, LAYER, BUILDER, IMAGE_VERSION)
	docker run --rm -it -d --name ML-env $(REGISTRY_URL)/$(PROJECT_NAME):$${LAYER}-$(BUILDER)-py$(PYTHON_VERSION)-$(IMAGE_VERSION)

docker-interactive: ## Enter into the machine-learning-environments container
	docker exec -it ML-env /bin/bash

start: ## Start the machine-learning-environments container
	docker start ML-env

stop: ## Stop the machine-learning-environments container
	docker stop ML-env

clean: ## Remove the machine-learning-environments container
	docker rm ML-env

docker-system-prune:
	docker system prune

run-within-container:  ## Execute a specified Python file within a pre-started container.  (args : SCRIPT_FILE)
	@echo "Executing the specified Python file within a pre-started container..."
	docker cp ${PWD}/scripts ML-env:/home
	docker exec -it ML-env python /home/scripts/$(SCRIPT_FILE)

run-in-container: ## Execute a specified Python file within a container without requiring prior startup. (args : SCRIPT_FILE)
	@echo "Executing the specified Python file within a container without requiring prior startup..."
	docker run -it --rm -v "${PWD}"/scripts:/home/scripts -w /home nielsborie/machine-learning-environments:${LAYER}-conda-py3.11--upgrade_and_refactos -c "python /home/scripts/$(SCRIPT_FILE)"

### RELEASE ###
## Generate/Update CHANGELOG.md file
generate-changelog:
	gitmoji-changelog

### GitHub action test ###
test_github_actions:
	act --job create_release --eventpath tests/resources/trigger-release.event