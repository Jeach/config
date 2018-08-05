#!/bin/bash
#----------------------------------------------------------------------------------------
# Install the docker community edition (ce) package.
#----------------------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved
#----------------------------------------------------------------------------------------
# 


#----------------------------------------------------------------------------------------
# According to the Docker web site instructions:
#   https://docs.docker.com/install/linux/docker-ce/debian/#set-up-the-repository
#----------------------------------------------------------------------------------------
installDocker() {
  print Docker
  sudo apt-get remove docker docker-engine docker.io
  sudo apt-get update
  sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce
  #sudo docker run hello-world
}

installDocker
