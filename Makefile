.PHONY: all

THIS_FILE:=$(lastword $(MAKEFILE_LIST))
CODE_TAG?=$(shell git describe --exact-match --tags 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
BUILD_NUMBER?=latest
PROJECT?=bitcoin-lib

########################################################

all: clean build

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[0-9a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## clean project
	rm -rf target/

build: ## build project
	docker rm -f $(PROJECT)-$(BUILD_NUMBER) 2>/dev/null ||:
	docker build --rm -f Dockerfile -t local/$(PROJECT):$(CODE_TAG) .

	mkdir -p target/
	docker run -d --name $(PROJECT)-$(BUILD_NUMBER) local/$(PROJECT):$(CODE_TAG) sleep 600
	docker cp $(PROJECT)-$(BUILD_NUMBER):/src/bitcoin-lib/target/bitcoin-lib_2.11-0.9.19-SNAPSHOT.jar target/bitcoin-lib_2.11-0.9.19-SNAPSHOT.jar
	docker rm -f $(PROJECT)-$(BUILD_NUMBER)
