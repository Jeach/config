#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2014 Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Create an encrypted escrow artifact.
#-----------------------------------------------------------------------------
# 2014.09.17 - v1.0.0 - Christian Jean - First created
#-----------------------------------------------------------------------------
# Description: 
#
#  This script will allow the creation of a fully encrypted escrow artifact 
#  from a Git repository.
#
#  At the time this tool was created, there was no easy way to checkout all
#  branches from a Git repository, other than to loop through them all.
#
# Our crypt tool:
#
#  Site url : https://packages.debian.org/wheezy/ccrypt
#  From     : Debian 'ccrypt' package
#  Install  : apt-get install ccrypt
#
# TODO:
#
#  + We should parse command line arguments in a more elegant manner
#  + We could make more options interactive via command line input
#  + We could auto generate a PDF file instead of the 'txt' version
#

set -x

#-----------------------------------------------------------------------------
# Source our libraries...
#-----------------------------------------------------------------------------
. sh/toolbox.sh

SCRIPT=${0##*/}
VERSION=1.0.0

ORG="Organization, Inc."

PKG=some-git-package
SCM=GitHub

TS=$(date +'%Y-%m-%d')
DIR=/tmp/escrow

LOG_PATH=/var/log
LOG_FILE=${SCRIPT%.*}.log

ENC_TOOL=/usr/bin/ccrypt

UUID=/proc/sys/kernel/random/uuid

SCM_DESC="None available"


#-----------------------------------------------------------------------------
# PURPOSE   : Create the escrow file (compressed tarball)
#-----------------------------------------------------------------------------
function doNames() {
   ESC_FILE=$DIR/$PKG-$TS-$$.tgz
   INF_FILE=$DIR/$PKG-$TS-$$.inf
   KEY_FILE=$DIR/$PKG-$TS-$$.key
   ENC_FILE=$DIR/$PKG-$TS-$$.enc
   TXT_FILE=$DIR/$PKG-$TS-$$.txt

   DEC_COMMAND="$(basename $ENC_TOOL) -c $(basename $ENC_FILE) > $(basename $ESC_FILE)"
}

#-----------------------------------------------------------------------------
# PURPOSE   : Checkout every branch of repository
#-----------------------------------------------------------------------------
function doCheckout() {
   log "Retrieving all branches..."

   TS=$(date +'%s')

   for i in $(git branch --all); do
      local BRANCH="${i:0:15}"
      local NAME="${i:15}"
      #local NAME="${i##*/}"

      log " * Branch: full='$i', branch='$BRANCH', name='$NAME'"

      [ -z $NAME ] && continue

      git checkout $NAME &> /tmp/git-checkout-$TS.log
      RET=$?

      if [ $RET -eq 0 ]; then
         log " * Successfully checked out branch '$NAME'"
      else 
         log " * Warning: Could not check out branch '$NAME' (code $RET), continuing!"
      fi
   done
}

#-----------------------------------------------------------------------------
# PURPOSE   : Get a short description via the command line (interactive).
#-----------------------------------------------------------------------------
function getDescription() {
   echo 
   echo "Please provide a short one-line description on the context of this '$PKG' escrow package."
   echo
   echo "Examples:"
   echo 
   echo "  Package 4.1, under development"
   echo "  Some Product 2.0.5-RC2"

   local DONE=

   while [ ! "$DONE" ]; do
      echo
      read -p "Description: " desc

      echo 
      echo "You wrote: '$desc'"
      echo 
      read -p "Is this ok? [Y/y/N/n] " conf
   
      if [ $conf == "Y" -o $conf == "y" ]; then
         DONE=yes
         SCM_DESC=$desc
      fi
   done
}

#-----------------------------------------------------------------------------
# PURPOSE   : Create the escrow file (compressed tarball)
#-----------------------------------------------------------------------------
function doEscrow() {
   log "Logging to '$LOG_PATH/$LOG_FILE'"

   log "Creating '$DIR' temp directory"
   mkdir -p $DIR | toLog
   RET=$?

   [ $RET -eq 0 ] && log " + Successfully created"
   [ $RET -ne 0 ] && log " + Error (code $RET), aborting!" && exit 1

   log "Creating '$ESC_FILE' escrow artifact"
   log " + Archiving $(find . -type f | wc -l) files and directories"
   log " + Archiving $(du -hs | awk '{ print $1 }') of content"

   tar zcf $ESC_FILE . | toLog
   RET=$?

   [ $RET -eq 0 ] && log " + Successfully created"
   [ $RET -ne 0 ] && log " + Error (code $RET), aborting!" && exit 1
}

#-----------------------------------------------------------------------------
# PURPOSE   : Create the escrow meta-data file
#-----------------------------------------------------------------------------
function doMetaData() {
   log "Creating '$INF_FILE' meta-data"

   OUT=$INF_FILE

   echo "=============================================================================" > $OUT
   echo "${ORG}" >> $OUT
   echo "=============================================================================" >> $OUT
   echo >> $OUT
   echo >> $OUT
   echo "Meta-data for '$PKG' Software Escrow" >> $OUT
   echo "-----------------------------------------------------------------------------" >> $OUT
   echo >> $OUT
   echo "Filename       : $(basename $ESC_FILE)" >> $OUT
   echo "Created        : $(date)" >> $OUT
   echo "Packager       : $(git config --get user.name) <$(git config --get user.email)>" >> $OUT
   echo "Repository     : $SCM" >> $OUT
   echo "Description    : $SCM_DESC" >> $OUT
   echo "SHA-1 (tgz)    : $(sha1sum $ESC_FILE | awk '{ print $1 }')" >> $OUT

   # Log info to stdout and file...
   cat $INF_FILE | tail -6 | sed 's/^/ + /g' | sed 's/ \{2,\}/ /g' | toLog

   echo >> $OUT
}

#-----------------------------------------------------------------------------
# PURPOSE   : Generate a random UUID key
#-----------------------------------------------------------------------------
function doRandKey() {
   log "Generating random UUID key"

   [ ! -e $UUID ] && log "ERROR: Could not generate a random UUID, leaving!" && exit 1
   
   cat $UUID > $KEY_FILE
   RET=$?

   [ $RET -eq 0 ] && log " + Successfully created key"
   [ $RET -ne 0 ] && log " + Failed to create key" && exit 1

   #echo " + Key is '$(cat $KEY_FILE)'" | toLog
}

#-----------------------------------------------------------------------------
# PURPOSE   : Encrypts our escrow file
# COMMENT   : We parse the version output (keep a watch for that)
#-----------------------------------------------------------------------------
function doEncrypt() {
   OUT=$INF_FILE

   log "Encrypting '$ESC_FILE' escrow file"

   [ ! -x $ENC_TOOL ] && log "ERROR: Crypt tool '$ENC_TOOL' could not be found!" && exit 1

   echo "Crypt tool     : $ENC_TOOL" >> $OUT
   echo "Crypt version  : $(ccrypt --version | head -1 | awk '{ print $1 " " $2 }')" >> $OUT
   
   $ENC_TOOL -e -k $KEY_FILE $ESC_FILE
   RET=$?

   [ $RET -eq 0 ] && log " + Successfully encrypted file"
   [ $RET -ne 0 ] && log " + Failed to encrypt file" && exit 1

   mv $ESC_FILE.cpt $ENC_FILE

   echo "SHA-1 (enc)    : $(sha1sum $ENC_FILE | awk '{ print $1 }')" >> $OUT

   # Log info to stdout and file...
   cat $INF_FILE | tail -3 | sed 's/^/ + /g' | sed 's/ \{2,\}/ /g' | toLog
}

#-----------------------------------------------------------------------------
# PURPOSE   : Generate a printable version of the file
#-----------------------------------------------------------------------------
function doPrintable() {
   log "Generating a printable version ('$(basename $TXT_FILE)')"

   cat $INF_FILE > $TXT_FILE
   echo >> $TXT_FILE
   echo "Encryption key : $(cat $KEY_FILE)" >> $TXT_FILE
   echo "To decrypt run : $DEC_COMMAND" >> $TXT_FILE
}

#-----------------------------------------------------------------------------
# PURPOSE   : Cleans every escrow file from temp directory
#-----------------------------------------------------------------------------
function doClean() {
   log "Cleaning '$DIR' temp directory"
   
   if [ -d $DIR ]; then
      LIST=$(find $DIR -maxdepth 1 -type f | grep '[a-zA-Z]\+-[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}-[0-9]\+.\(enc\|inf\|key\|txt\)')

      for i in $LIST; do
         if [ -f $i ]; then
            log " > Deleting '$(basename $i)'"
            rm -f "$i"
            [ $? -ne 0 ] && log "Could not remove file '$i'"
         fi
      done
   fi
}

#-----------------------------------------------------------------------------
# PURPOSE   : List the content of the temp directory 
#-----------------------------------------------------------------------------
function doList() {
   log "Listing '$DIR' temp directory"

   if [ -d $DIR ]; then
      LIST=$(find $DIR -maxdepth 1)

      for i in $LIST; do
         [ -f $i ] && log " > Found '$i'"
      done
   fi
}

#-----------------------------------------------------------------------------
# Script entry point!
#-----------------------------------------------------------------------------
doCheckout

