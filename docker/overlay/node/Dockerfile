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

WORKDIR /home/nodejs/app

COPY package*.json .

RUN npm install

COPY . . 

RUN chown node:node -R /home/nodejs/app
RUN echo "root:Toto!1234" | chpasswd

EXPOSE 80

# By default, Docker runs container as root which inside of the container can
# pose as a security issue. You would want to run the container as an 
# unprivileged user wherever possible. The node images provide the node user 
# for such purpose. The Docker Image can then be run with the node user in the
# following way:
#
#   -u "node"
#
# Alternatively, the user can be activated in the Dockerfile. At the end, set 
# the user to use when running this image.
USER node

CMD ["node", "server.js"]
