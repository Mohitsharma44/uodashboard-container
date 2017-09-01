.PHONY: help build test refresh run

OWNER:=mohitsharma44
UODASH_STACK:=uodashboard-container
VERSION:=dev
IMG_NAME:=uodashboard-container
LOCAL_PORT:=30000
CONTAINER_PORT:=30000
GIT_MASTER_HEAD_SHA:=$(shell git rev-parse --short=12 --verify HEAD)

RETRIES:=10

help:
	@printf "\033[0;33mDefault image: mohitsharma44/uodashboard-container:\033[0;31m$(VERSION) \033[0m"
	@echo
	@echo "====================="
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "====================="
	@echo "\033[0;33mReplace % by the image name.\033[0m"
	@echo

build/%: DARGS?=
build/%: ## build the image for the uodash stack
	docker build $(DARGS) --rm --force-rm -t $(OWNER)/$(notdir $@):$(VERSION) ./image

run/%: ## run the docker image pulled from dockerhub
	docker run -d --name $(IMG_NAME) -p $(CONTAINER_PORT):$(LOCAL_PORT) $(OWNER)/$(notdir $@):$(VERSION)

refresh/%: ## pull the image from Docker Hub for a stack
           # skip if error: a stack might not be on dockerhub yet
	-docker pull $(OWNER)/$(notdir $@):$(VERSION)

test/%: ## run the stack and check if the server is alive
	@-docker rm -f $(IMG_NAME)
	@docker run -d --name $(IMG_NAME) -p $(CONTAINER_PORT):$(LOCAL_PORT) $(OWNER)/$(notdir $@):$(VERSION)
	@echo "Checking for UODash Server"
	@for i in $$(seq 0 9); do \
		sleep $$i; \
                printf ". "; \
		wget -q http://localhost:$(CONTAINER_PORT) -O- | grep -i "Urban Observatory / Audubon Site" &> /dev/null; \
		if [ $$? = 0 ]; then \
                echo; \
                echo "Server is Up and Running"; \
                exit 0; \
                fi; \
	done; \
        echo "\033[0;31mServer is Not Running\033[0m"; \
        exit 1

clean/%: ## Delete the container and image
	@-docker rm -f $(IMG_NAME)
	@-docker rmi -f $(OWNER)/$(notdir $@):$(VERSION)

## If simply run `make`, return help
.DEFAULT_GOAL := help

build:$(UODASH_STACK:%=build/%)
refresh:$(UODASH_STACK:%=refresh/%)
test:$(UODASH_STACK:%=test/%)
run:$(UODASH_STACK:%=run/%)
clean:$(UODASH_STACK:%=clean/%)
