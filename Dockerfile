FROM ubuntu:18.04
MAINTAINER George Williams "gwilliams@ieee.org"

#
# Linux prep
#
RUN apt-get update && apt-get install -y vim && apt-get install -y nano

#
# Conda prep
#
COPY ./miniconda.sh /root/miniconda.sh
RUN bash /root/miniconda.sh -b -p /root/miniconda
ENV PATH="/root/miniconda/bin:${PATH}"
RUN conda init bash

# Make RUN commands use bash going forward:
SHELL ["/bin/bash", "-c"] 

#
# Belex conda_channel prep
#
COPY ./conda_channel /root/conda_channel
RUN cd /root/conda_channel && conda config --set custom_channels.gsi file://$PWD

#
# Copy over remaining belex repos
#
COPY ./belex /root/belex
COPY ./belex-libs /root/belex-libs
COPY ./belex-tests /root/belex-tests

# Create the emulation conda environment
RUN cd /root/belex-tests &&  conda env create -f environment_emulation.yml 

# Make RUN commands use the new conda env through bash
SHELL ["conda", "run", "-n", "belex-test_emulation", "/bin/bash", "-c"]

#
# Finalize belex setup
#
RUN cd /root/belex-tests && \
    conda install pudb -c conda-forge && \
    pip install -e ../belex -e ../belex-libs -e . && \
    pip install jsons

# Make sure docker shell exec defaults to belex-tests directory
WORKDIR /root/belex-tests
    
