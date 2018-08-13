#-----------------------------------------------------------------------------
# Create a custom docker image layered on top of the Node container.
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
# See: https://nodejs.org/en/docs/guides/nodejs-docker-webapp
#-----------------------------------------------------------------------------
#

FROM node:8

MAINTAINER Christian Jean <christian.jean@gmail.com>

#VOLUME ["/data"]

WORKDIR /jeach

# Install dependencies
COPY jeach.txt .

# Bundle app source
#COPY . . 

CMD ["bash"]
