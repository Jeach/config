#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2007 Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Script to grab different snapshots of a Linux operating system.
#-----------------------------------------------------------------------------
# 2007.11.23  CJ  First written
# 2008.03.16  CJ  Few minor changes and fixes
# 2008.12.14  CJ  Addition of options
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# CJ: Christian Jean <christian.jean@gmail.com>
#-----------------------------------------------------------------------------
#

SCRIPT=$(basename ${0%%.sh})
VERSION=1.0.2

TS=$(date +'%s')

SNAP=snapshot
NAME=$SNAP-$TS
FILE=$NAME.tgz
TEMP=/tmp
BASE=$TEMP/$NAME
INFO=$BASE/snapshot.log

TERMINATE=0


#-----------------------------------------------------------------------------
# PURPOSE   : Show a small help screen
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function showUsage() {
   echo "USAGE: $SCRIPT (v${VERSION})"
   echo
   echo "   --help            Show this screen"
   echo "   --version         Show the version number"
   echo
   echo "   --os              Gather an OS and kernel snapshot"
   echo "   --cpu             Gather a processor snapshot"
   echo "   --hw              Gather a hardware snapshot"
   echo "   --mem             Gather a memory snapshot"
   echo "   --io              Gather a input/output snapshot"
   echo "   --net             Gather a network snapshot"
   echo "   --logs            Gather log files (ie: /var/logs)"
   echo 
   echo "   --proc            Gather a /proc FS snapshot"
   echo "   --sysfs           Gather a /sys FS snapshot"
   echo 
   echo "   --clean           Clean all test directories"
   echo
   
   exit 0
}

#-----------------------------------------------------------------------------
# PURPOSE   : Handle unknown commands
# ARGS      : $1 is the command
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function showUnknown() {
   echo "$SCRIPT (v${VERSION})"
   echo "Unrecognized param: '$1'"
   echo "Run with '--help' param for a list of options"
   exit 0
}

#-----------------------------------------------------------------------------
# PURPOSE   : Log information to screen and to our log
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function log() {
   echo "[$(date +'%Y-%m-%d %H:%M:%S')][$$]> $1" | tee -a $INFO
}

#-----------------------------------------------------------------------------
# PURPOSE   : Determine if a command is available and log the status.
# ARGS      : none
# RETURNS   : nothing
# COMMENT   : Will always log what strategy is used (type, command or hash)
#           : on the first run.
#-----------------------------------------------------------------------------
function cmd() {
   case 0 in
      0) type $1 &> /dev/null; RET=$?
         [ -z $CMD1 ] && log "Using 'type' for command evaluation" && CMD1=1 ;;
      1) command -v $1 &> /dev/null; RET=$?
         [ -z $CMD1 ] && log "Using 'command' for command evaluation" && CMD1=1 ;;
      2) hash $1 &> /dev/null; RET=$?
         [ -z $CMD1 ] && log "Using 'hash' for command evaluation" && CMD1=1 ;;
   esac

   [ $RET -eq 0 ] && log "Command '$1', was found!"
   [ $RET -ne 0 ] && log "Command '$1', NOT found!"

   return $RET
}

#-----------------------------------------------------------------------------
# PURPOSE   : Copy a file from the filesystem into a specific folder.  Will 
#           : rename the file using the full path.
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function cpy() {
   if [ -f $1 ]; then 
      F=$(basename $1)
      echo "-----------------------------------------------------------------------------" >> $2/$F
      echo "Copy of: '$1'" >> $2/$F
      echo "-----------------------------------------------------------------------------" >> $2/$F
      cat $1 >> $2/$F
   else 
      log "Could not copy '$1' to '\$BASE/$(basename $2)'"
      terminate
   fi
}

#-----------------------------------------------------------------------------
# PURPOSE   : Terminate on errors when instructed to.
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function terminate() {
   [ $TERMINATE -gt 0 ] && log "Terminating!" && exit 0
}


#-----------------------------------------------------------------------------
# PURPOSE   : Grab an operating system (OS) & kernel snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profOS() {
   log "Grabbing an OS snapshot..."
   mkdir $BASE/os

   uname -a > $BASE/os/uname

   cmd uptime && uptime &> $BASE/os/uptime
   cmd lsb_release && lsb_release --all &> $BASE/os/lsb_release
   cmd dmesg && dmesg &> $BASE/os/dmesg

   cpy /etc/passwd $BASE/os
   cpy /etc/group $BASE/os
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab a CPU snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profCPU() {
   log "Grabbing a CPU snapshot..."
   mkdir $BASE/cpu

   cmd nproc && nproc &> $BASE/cpu/nproc
   cmd lscpu && lscpu &> $BASE/cpu/lscpu
   cmd cpuid && cpuid &> $BASE/cpu/cpuid

   cpy /proc/cpuinfo $BASE/cpu
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab a HW snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profHW() {
   log "Grabbing a HW snapshot..."
   mkdir $BASE/hw

   cmd lsusb && lsusb &> $BASE/hw/lsusb
   cmd lspci && lspci &> $BASE/hw/lspci
   cmd dmidecode && dmidecode &> $BASE/hw/dmidecode

   cpy /proc/bus/input/devices $BASE/hw
   cpy /proc/x/y/abcd $BASE/hw
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab a memory snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profMEM() {
   log "Grabbing a memory snapshot..."
   mkdir $BASE/mem

   cpy /proc/meminfo $BASE/mem
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab an input/output (IO) snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profIO() {
   log "Grabbing an IO snapshot..."
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab a network snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profNET() {
   log "Grabbing a network snapshot..."
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab a log snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profLogs() {
   log "Grabbing a logs snapshot..."
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab a /prof FS snapshot 
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profProcFS() {
   log "Grabbing a /proc FS snapsshot..."
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab a /sys FS snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function profSysFS() {
   log "Grabbing a /sys FS snapshot..."
}

#-----------------------------------------------------------------------------
# PURPOSE   : Grab ALL snapshot
# ARGS      : none
# RETURNS   : nothing
# COMMENTS  : This will turn off individual flags to prevent from doing it
#           : twice.
#-----------------------------------------------------------------------------
function profALL() {
   log "Grabbing ALL snapshots..."

   profOS
   profCPU
   profHW
   profMEM
   profIO
   profNET
   profLogs
   profProcFS
   profSysFS
}

#-----------------------------------------------------------------------------
# PURPOSE   : Initialize the snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function initSnapshot() {
   mkdir -p $BASE

   log "------------------------------------------------------------------------------"
   log "Created '$NAME' on '$(date)'"
   log "------------------------------------------------------------------------------"

   # Log our command evaluation process
   cmd test
}

#-----------------------------------------------------------------------------
# PURPOSE   : Finish the snapshot
# ARGS      : none
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function finishSnapshot() {
   log "------------------------------------------------------------------------------"
   log "Completed successfully, captured $(find $BASE/*/* -type f | wc -l) snapshots" 
}

#-----------------------------------------------------------------------------
# PURPOSE   : Handle unknown commands
# ARGS      : $1 is the command
# RETURNS   : nothing
#-----------------------------------------------------------------------------
function cleanup() {
   echo "Cleaning '$TEMP/$SNAP-*' directories..."
   for i in $(find $TEMP -maxdepth 1 -type d -name "$SNAP-*"); do
      echo " > Removing: '$i'"
      rm -rf "$i"
   done

   exit 0
}


#-----------------------------------------------------------------------------
# Script entry point
#-----------------------------------------------------------------------------
[ $# -eq 0 ] && showUsage


#-----------------------------------------------------------------------------
# Parse system commands
#-----------------------------------------------------------------------------
while [ $# -gt 0 ]; do
   #echo "ARG: $1"

   case "$1" in
      --help) showUsage ;;
      --clean) cleanup ;;

      --all) ALL=1 ;;
      --os)  OS=1 ;;
      --cpu) CPU=1 ;;
      --hw) HW=1 ;;
      --mem) MEM=1 ;;
      --io)  IO=1 ;;
      --net) NET=1 ;;
      --log|--logs) LOGS=1 ;;
      --proc|--procfs|--proc-fs) PROC=1 ;;
      --sysfs|--sys-fs) SYSFS=1 ;;

      *) showUnknown "$1" ;;
   esac

   shift
done


#-----------------------------------------------------------------------------
# Process commands
#-----------------------------------------------------------------------------

initSnapshot

[ ! -z $ALL ]   && profALL

[ ! -z $OS ]    && profOS
[ ! -z $CPU ]   && profCPU
[ ! -z $HW ]    && profHW
[ ! -z $MEM ]   && profMEM
[ ! -z $IO ]    && profIO
[ ! -z $NET ]   && profNET
[ ! -z $LOGS ]  && profLogs
[ ! -z $PROC ]  && profProcFS
[ ! -z $SYSFS ] && profSysFS

finishSnapshot

