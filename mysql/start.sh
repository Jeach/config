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
#
# There are essentially two ways to run the MySQL client:
#
#  1. From inside the container, by running the following command:
#
#     docker exec -it c6 mysql -uroot -p
#
#  2. By installing a MySQL client on the host machine, with the following
#     two commands:
#
#     apt-get install mysql-client
#
#     mysql -uroot -ptoto -h 127.0.0.1 -P 3306
#
# If you want to change the password, execute the following SQL command:
#
#   ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
#-----------------------------------------------------------------------------
#

# This assumes the client is installed on the host machine
mysql -uroot -ptoto -h 127.0.0.1 -P 3306

