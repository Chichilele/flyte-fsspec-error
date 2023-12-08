FROM --platform=linux/amd64 python:3.10-slim-bullseye AS base


WORKDIR /root
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /root
ENV PYTHONFAULTHANDLER=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONHASHSEED=random
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100
ENV POETRY_VERSION=1.6.1

RUN apt-get update && apt-get install -y build-essential curl unzip

# System deps:
RUN pip install poetry==$POETRY_VERSION
FROM base AS poetry-env

COPY pyproject.toml poetry.lock README.md /root/
RUN poetry config virtualenvs.create false  && \
    poetry install --no-interaction --no-ansi

# fixes flytekit error "Original exception: module 'aiobotocore' has no attribute 'AioSession'
# https://flyte-org.slack.com/archives/CP2HDHKE1/p1699480698102759?thread_ts=1699480689.690139&cid=CP2HDHKE1
# RUN pip install fsspec==2023.10.0 gcsfs==2023.10.0 s3fs==2023.10.0

RUN rm -rf /root/.cache/pypoetry

ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
