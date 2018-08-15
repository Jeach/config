#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2018 Chrsitian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Script to start the MySQL engine from a Docker container.
#-----------------------------------------------------------------------------
# Note that you must specify an IP address when using a container because it
# can't connect via socket, which is default behavior.
#
# Use the following to start the container:
#
#   docker run -p 3306:3306 -d --env="MYSQL_ROOT_PASSWORD=toto" mysql:5.7.23
#
# Important: Do NOT use the 'mysql:latest' (or version 8.0) container, since
# it seems to be seriously broken.
#-----------------------------------------------------------------------------
#

mysql -uroot -ptoto -h 127.0.0.1 -P 3306

