#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
# This script will build the current Docker image.
#

USER="jeach"
IMAGE=$(cat Dockerfile | grep FROM | cut -d' ' -f2 | cut -d':' -f1)
VERSION=1.1

#VER=$(sudo npm version minor)

echo -e "\nBuilding image:\n"
echo " + Image   : $IMAGE"
echo " + User    : $USER"
echo " + Version : $VERSION"
echo " + Image   : ${USER}-${IMAGE}:${VERSION}"
echo

sudo docker build -t ${USER}-${IMAGE}:${VERSION} .
