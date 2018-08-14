#-----------------------------------------------------------------------------
# Create a custom docker image layered on top of the Ubuntu container.
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
# See: https://nodejs.org/en/docs/guides/nodejs-docker-webapp
#-----------------------------------------------------------------------------
#

FROM ubuntu

MAINTAINER Christian Jean <christian.jean@gmail.com>

#VOLUME ["/data"]

WORKDIR /jeach
COPY jeach.txt .

WORKDIR /jeach/one
COPY one.txt .

WORKDIR /jeach/two
COPY two.txt .

WORKDIR /

CMD ["bash"]
