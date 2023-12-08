.PHONY: tests clean clean-test clean-pyc clean-build docs help

export APP_VERSION ?= 0.1.0
export IMAGE_NAME = flyte-fsspec-error

export DOCKER_TAG = ${IMAGE_NAME}:${APP_VERSION}

docker_build:
	@echo "Building image... ${DOCKER_TAG}"
	@docker build -t ${DOCKER_TAG} \
		--target runtime \
		--build-arg tag=${APP_VERSION} \
		.

docker_push:
	@echo "Pushing image... ${DOCKER_TAG}"
	@docker push ${DOCKER_TAG}
	
requirements.txt:
	poetry export -f requirements.txt --output requirements.txt

clean
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +
