#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Copy this script to the '/usr/sbin' folder and then add the following
# crontab rule to '/etc/crontab':
#
# 30 3    * * *   root    /usr/sbin/gcp-crontab.sh
#-----------------------------------------------------------------------------
#

AUDIT_LOG=~/.gcp-crontab.log

function haltVM() {
  echo "$(date):> Auto shutdown (crontab rule)" >> $AUDIT_LOG
  shutdown -h now
}

haltVM

