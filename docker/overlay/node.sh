#-----------------------------------------------------------------------------
# Create a custom docker image layered on top of the node:8 container.
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
# See: https://nodejs.org/en/docs/guides/nodejs-docker-webapp
#-----------------------------------------------------------------------------
#

FROM node:8

MAINTAINER Christian Jean <christian.jean@gmail.com>
#LABEL maintainer="SvenDowideit@home.org.au"

#VOLUME ["/data"]

WORKDIR /tmp/node-test

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install

# If you are building your code for production
RUN npm install --only=production

# Bundle app source
COPY . . 

# The app binds to TCP port 80
EXPOSE 80/tcp

# Define the command to run your app using CMD which defines your runtime. 
# Here we will use the basic npm start which will run node server.js to start
# your server:
CMD ["npm", "start"]
