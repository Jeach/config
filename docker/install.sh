#!/bin/bash
#----------------------------------------------------------------------------------------
# Install the docker community edition (ce) package.
#----------------------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved
#----------------------------------------------------------------------------------------
# Installed by detecting the Linux image ($> lsb_release -a):
#
#   No LSB modules are available.
#   Distributor ID: Debian
#   Description:    Debian GNU/Linux 9.5 (stretch)
#   Release:        9.5
#   Codename:       stretch
#-----------------------------------------------------------------------------
# Various docker commands:
#
#   docker images   # To list all installed images
#   docker ps       # To list all running instances
#
#   // Run a docker container
#   docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]
#
#   // Start the nginx service in a container
#   docker run -d -p 80:80 my_image service nginx start
#


#----------------------------------------------------------------------------------------
# Detect the Linux distro ('ubuntu' or 'debian')
#----------------------------------------------------------------------------------------
DISTRO=$(lsb_release -i | cut -d: -f2 | sed 's/[[:space:]]*//g' | sed -e 's/\(.*\)/\L\1/')

#----------------------------------------------------------------------------------------
# Determine the system architecture
#----------------------------------------------------------------------------------------
# a) amd64 = x86_64/amd64
# b) armhf = ARM hard float (armv7+)
# c) arm64 = ARM 64-bit (armv8+)
#ARCH=$(dpkg --print-architecture)

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
  #sudo apt-key fingerprint 0EBFCD88    # For manual verification
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/${DISTRO} $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce
}

#----------------------------------------------------------------------------------------
# Install the Docker Compose utility
#----------------------------------------------------------------------------------------
installDockerCompose() {
  sudo apt-get update
  sudo apt-get install docker-compose
}

installDocker
installDockerCompose
