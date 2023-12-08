# flyte-fsspec-error


Showcases flyte error where depending on the `fsspec` version, a workflow run will either fail locally or on the flyte platform.

Related threads on flyte's community slack:
- https://flyte-org.slack.com/archives/CP2HDHKE1/p1698215524025349?thread_ts=1698044484.843609&cid=CP2HDHKE1
- https://flyte-org.slack.com/archives/CP2HDHKE1/p1699480689690139

## Setup

This repo is setup with poetry. I've exported the `requirements.txt` file for convenience. There are some helpers in the `Makefile` to build the docker image and push it to your repo.

The current workaround I use is commented in the dockerfile [here](./Dockerfile#L28).

## Steps to reproduce

```bash
# Clone this repo
git clone https://github.com/Chichilele/flyte-fsspec-error.git

# Builder docker image
docker build -t flyte-fsspec-error .

# tag to your convinience
docker tag flyte-fsspec-error:latest <MY_REPO>/flyte-fsspec-error:0.1.0

# push to your repo
docker push <MY_REPO>/flyte-fsspec-error:0.1.0

# Run workflow locally
# This works thanks to the fsspec version in the requirements
pyflyte run error.py my_workflow

# Run workflow on flyte platform
# This fails with the pinned fsspec version
pyflyte run --remote \
    --image  <MY_REPO>/flyte-fsspec-error:0.1.0 \
    error.py my_workflow
```

Now if you uncomment the following line in docker image, it should work on the flyte platform.
```dockerfile
RUN pip install fsspec==2023.10.0 gcsfs==2023.10.0 s3fs==2023.10.0
```