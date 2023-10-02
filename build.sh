#!/bin/bash

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
#    cd "conda_channel" && git pull && cd ..
else
    git clone --branch master git@bitbucket.org:gsitech/conda_channel.git
fi

#
# clone 'belex' as needed
#
if [ -d "belex" ]; then
    echo "Found belex"
#    cd "belex" && git pull && cd ..
else
    git clone --branch master git@bitbucket.org:gsitech/belex.git
fi

#
# clone 'belex-libs' as needed
#
if [ -d "belex-libs" ]; then
    echo "Found belex-libs"
#    cd "belex-libs" && git pull && cd ..
else
    git clone --branch master git@bitbucket.org:gsitech/belex-libs.git
fi

#
# clone 'belex-tests' as needed
#
if [ -d "belex-tests" ]; then
    echo "Found belex-tests"
#    cd "belex-tests" && git pull && cd ..
else
    git clone --branch master git@bitbucket.org:gsitech/belex-tests.git
fi

#
# download miniconda installer
#
if [ -f "miniconda.sh" ]; then
    echo "Found miniconda installer..."
else
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
fi


docker build -f ./Dockerfile -t gsicompiler/belex .
