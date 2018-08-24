#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved.
#-----------------------------------------------------------------------------
# This script will build a Node Docker image.
#


SCRIPT_NAME=${0##*/}
SCRIPT_VER="1.2"

NCONF=package.json
DCONF=Dockerfile
DIGN=.dockerignore

ORG=
IMAGE=
VERSION=
BASE=
NAME=

function showHelp() {
  echo "$SCRIPT_NAME [options] <node_directory>"
  echo 
  echo "Where OPTIONS are:"
  echo
  echo "  -v, --ver, --version          Provides a default version number"
  echo "  -i, --img, --image            Provides a default package name (same as -n, --name)"
  echo "  -o, --org, --organization     Provide the default organization name"
  echo "  -d, --dir, --directory        Provides the default 'node-directory' of Node project"
  echo
  echo "  -h, --help                    Show this help menu"
  echo
  echo "If a value for 'organization', 'image', or 'version' is provided through the options arguments, "
  echo "they will be used explicitly."
  echo
  echo "Next, will attempt to read the '${NCONF}' file to parse the 'image' and 'version' information."
  echo 
  echo "If no 'image' has been specified, will use the 'FROM' value of the '${DCONF}' as last measure."
  echo
  echo "Will construct an image name using: "
  echo
  echo "  [image]:[version]                       // Example:   mynode:1.2.3 "
  echo "  [organization]-[image]:[version]        // Example:   jeach-mynode:1.2.3 "
  echo
  echo "The 'organization' value is used in the name only if it is provided (there are no default value)"
  echo

  exit 0
}

function getVersion() {
  grep version "$1" | cut -d: -f2 | sed 's/[ ,\"]*//g'
}

function getImage() {
  grep name "$1" | cut -d: -f2 | sed 's/[ ,\"]*//g'
}

[ $# -eq 0 ] && showHelp

[ ! -e "$DCONF" ] && echo "Could not find Docker config file ('$DCONF'), leaving!" && exit 1

while [ $# -gt 0 ]; do
  [ "${1:0:1}" != "-" ] && break
  case "$1" in
    -h|--help) showHelp ;;
    -v|--ver|--version) shift; VERSION=$1 ;;
    -i|--img|--image) shift; IMAGE=$1 ;;
    -d|--dir|--directory) shift; BASE=$1 ;;
    -o|--org|--organization) shift; ORG=$1 ;;
    -*) echo "Unknown option ('$1'), ignoring!" ;;
  esac
  shift 
done

[ -z $BASE ] && [ $# -gt 0 ] && BASE=$1

[ -z "$BASE" ] && echo "No node project directory was provided, leaving!" && exit 2
[ ! -d "$BASE" ] && echo "No such directory ('$BASE'), leaving!" && exit 2

if [ -e "$BASE/$NCONF" ]; then
  [ -z $IMAGE ] && IMAGE=$(getImage $BASE/$NCONF)
  [ -z $VERSION ] && VERSION=$(getVersion $BASE/$NCONF)
fi

[ -z $VERSION ] && VERSION=latest

[ -z $IMAGE ] && IMAGE=$(cat $DCONF | grep FROM | cut -d' ' -f2 | cut -d':' -f1)

if [ -z $ORG ]; then
  NAME=${IMAGE}:${VERSION}
else 
  NAME=${ORG}-${IMAGE}:${VERSION}
fi

showStatus() {
  echo -e "\nBuilding node image:\n"
  echo " + Organization   : ${ORG:-<n/a>}"
  echo " + Project name   : $IMAGE"
  echo " + Image version  : $VERSION"  
  echo " + Image name     : $NAME"
  echo " + Node directory : $BASE"
  echo
}

showStatus

cp $DCONF $BASE
echo -e "${DCONF}\n${DIGN}\n.git\n" > $BASE/$DIGN

pushd ${BASE} &> /dev/null
[ $? -ne 0 ] && echo "Could not move to '$BASE', aborting!" && exit 1

sudo docker build -t $NAME .

[ -e $DIGN ] && rm -f "$DIGN"
[ -e $DCONF ] && rm -f "$DCONF"

