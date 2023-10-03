#!/bin/bash

#
# build config
#
BRANCH=develop
TESTS_BRANCH=develop #brian-hdc-2
TIMESTAMP=$(date +%s)

#
# bash config
#
set -e
set -x

#
# override docker build features
#
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

#
# clone 'conda_channel' as needed
#
if [ -d "conda_channel" ]; then
    echo "Found conda_channel"
    cd "conda_channel" && git fetch && git checkout master && git pull && cd ..
else
    git clone --branch master git@bitbucket.org:gsitech/conda_channel.git
fi

#
# clone 'belex' as needed
#
if [ -d "belex" ]; then
    echo "Found belex"
    cd "belex" && git fetch && git checkout ${BRANCH} && git pull && cd ..
else
    git clone --branch ${BRANCH} git@bitbucket.org:gsitech/belex.git
fi

#
# clone 'belex-libs' as needed
#
if [ -d "belex-libs" ]; then
    echo "Found belex-libs"
    cd "belex-libs" && git fetch && git checkout ${BRANCH} && git pull && cd ..
else
    git clone --branch ${BRANCH} git@bitbucket.org:gsitech/belex-libs.git
fi

#
# clone 'belex-tests' as needed
#
if [ -d "belex-tests" ]; then
    echo "Found belex-tests"
    cd "belex-tests" && git fetch && git checkout ${TESTS_BRANCH} && git pull && cd ..
else
    git clone --branch ${TESTS_BRANCH} git@bitbucket.org:gsitech/belex-tests.git
fi

#
# download miniconda installer
#
if [ -f "miniconda.sh" ]; then
    echo "Found miniconda installer..."
else
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
fi

# create a tab containing branch and timestamp
TAG="${TESTS_BRANCH}-$TIMESTAMP"

# build the container
docker build -f ./Dockerfile -t gsicompiler/belex:$TAG .

# push to repository
docker tag gsicompiler/belex:$TAG 182642843343.dkr.ecr.us-east-1.amazonaws.com/gsicompiler/belex:$TAG
docker push 182642843343.dkr.ecr.us-east-1.amazonaws.com/gsicompiler/belex:$TAG


