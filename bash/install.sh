#!/bin/bash
#-----------------------------------------------------------------------------
# Install our custom BASH configuration ('.bashrc.jeach')
#-----------------------------------------------------------------------------
# Copyright (C) 2013 Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Invoking this script will:
#
#  1. Add a call trigger to '~/.bashrc.jeach' into the '~/bashrc' script.
#     Note that this action is idempotent and can be called frequently.
#
#  2. Will copy the '.bashrc.jeach' script to the '~/' folder.
#

SCRIPT="~/.bashrc.jeach"
BASHRC=~/.bashrc

grep "Jeach Config" $BASHRC &> /dev/null

if [ $? -eq 1 ]; then
  echo "Adding '~/.bashrc' trigger..."
  echo -e "\n# Jeach Config\n[ -e $SCRIPT ] && . $SCRIPT\n" >> $BASHRC
fi

echo "Copying '${SCRIPT:2}' to '~/'"
cp -f ${SCRIPT:2} ~/

