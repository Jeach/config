#!/bin/bash
#-----------------------------------------------------------------------------
# Clone a GitHub repository
#-----------------------------------------------------------------------------
# Copyright (C) 2015 by Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
#

TS=$(date +'%Y%m%d-%H%M%S')

# Define Git user/organization
ORG=Jeach

# Define the repo to be used
REPO=${1:-workspace}

# Now invoke the Git clone command
echo "Cloning GIT repository:"
echo
echo " > User/org    : '$ORG'"
echo " > Repository  : '$REPO'"
echo " > Target dir  : '${REPO}-$TS'"
echo " > Command     : 'git clone https://github.com/${ORG}/${REPO}.git ${REPO}-$TS'"
echo
echo "Starting..."

git clone https://github.com/${ORG}/${REPO}.git ${REPO}-$TS
