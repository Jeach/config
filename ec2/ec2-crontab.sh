#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2020 Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Programatically add a crontab rule to shutdown the EC2 at 03:00 every day.
# Currently set for 03:30 every night, non-UTC (beware of sytem UTC times).
# Local 03:30 ETC is 07:30 UTC-04 or 08:30 UTC-05.
#-----------------------------------------------------------------------------
#

CRONTAB=/etc/crontab
SCRIPT=/usr/sbin/ec2-crontab.sh
AUDIT_LOG=~/.ec2-crontab.log
RULE_NAME="Jeach EC2 auto-shutdown rule"


[ "$(whoami)" != "root" ] && \
  echo "Must run this script with root priviledges!" && \
  echo "Use the 'sudo' command to invoke this script." && \
  echo "Aborting!" && \
  exit 1

[ ! -f $CRONTAB ] && \
  echo "No '$CRONTAB' file found, aborting!" && \
  exit 1

cat $CRONTAB | grep "$RULE_NAME" &> /dev/null
RET=$?

#echo "Result: $RET"

[ $RET -eq 0 ] && \
  echo "Rule already exists, aborting!" && \
  exit 0

echo "No custom $RULE_NAME found"
echo "Adding rule to crontab table!"

# Add rule to crontab table
echo >> $CRONTAB
echo "# $RULE_NAME" >> $CRONTAB
echo "30 3  * * * root  $SCRIPT" >> $CRONTAB
echo >> $CRONTAB

echo "Creating our first audit log entry!"

# Create our first entry in audit log
echo "$(date):> EC2 auto shutdown rule installed in crontab" >> $AUDIT_LOG

echo "Creating our crontab script at '$SCRIPT'"

# Now create our crontab script
cat <<EOT>> $SCRIPT
#!/bin/bash
#-----------------------------------------------------------------------------
# Copyright (C) 2020 Christian Jean
# All Rights Reserved
#-----------------------------------------------------------------------------
# Shutdown the EC2 every night and append to audit log (see crontab rule).
#-----------------------------------------------------------------------------
#

AUDIT_LOG=~/.ec2-crontab.log

function haltVM() {
  echo "\$(date):> EC2 auto shutdown (crontab rule)" >> \$AUDIT_LOG
  shutdown -h now
}

haltVM
EOT

echo "Changing script permissions!"
chmod +x $SCRIPT

echo "All done, leaving!"
exit 0
