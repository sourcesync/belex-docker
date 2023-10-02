FROM ubuntu:18.04
MAINTAINER George Williams "gwilliams@ieee.org"

#
# Linux prep
#
RUN apt-get update

#
# Conda prep
#
COPY ./miniconda.sh /root/miniconda.sh
RUN bash /root/miniconda.sh -b -p /root/miniconda
ENV PATH="/root/miniconda/bin:${PATH}"

#
# Belex conda_channel prep
#
COPY ./conda_channel /root/conda_channel
RUN cd /root/conda_channel && conda config --set custom_channels.gsi file://$PWD

#
# Copy over remaining belex repos
COPY ./belex /root/belex
COPY ./belex-libs /root/belex-libs
COPY ./belex-tests /root/belex-tests

