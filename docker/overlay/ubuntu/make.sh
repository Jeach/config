#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
# This script will build the current Docker image.
#

USER="jeach"
IMAGE=$(cat Dockerfile | grep FROM | cut -d' ' -f2 | cut -d':' -f1)

echo -e "\nBuilding image:\n"
echo " + Image : '$IMAGE'"
echo " + User  : '$USER'"
echo

sudo docker build -t ${USER}-${IMAGE} .
