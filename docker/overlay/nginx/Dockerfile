#-----------------------------------------------------------------------------
# Create a custom docker image layered on top of the Node container.
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
# See: https://nodejs.org/en/docs/guides/nodejs-docker-webapp
#-----------------------------------------------------------------------------
# By default, the configuration file is named 'nginx.conf' and placed in 
# the directory:
#
#   /etc/nginx                  [yes, default image]
#   /usr/local/nginx/conf       [no, not default image]
#   /usr/local/etc/nginx        [no, not default image]
#
# The process ID of the nginx master process is written, by default, to
# the 'nginx.pid' in the directory:
#
#   /var/run                    [yes, default image]
#   /usr/local/nginx/logs       [no, not default image]
#
# Found logs in (redirecting to):
#
#   /var/log/nginx/access.log -> /dev/stdout
#   /var/log/nginx/error.log -> /dev/stderr
#
# Also found the following files:
#
#   /usr/share/nginx/html/50x.html
#   /usr/share/nginx/html/index.html
#-----------------------------------------------------------------------------
#

FROM nginx:latest

MAINTAINER Christian Jean <christian.jean@gmail.com>

#WORKDIR /home/nodejs/app

#VOLUME /home/nodejs/share

#COPY package*.json .

RUN mkdir -p /data/js
RUN mkdir -p /data/css
RUN mkdir -p /data/images

#COPY . . 

#EXPOSE 8080

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

#CMD ["node", "server.js"]
