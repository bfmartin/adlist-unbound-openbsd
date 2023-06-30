#!/bin/sh
#
# this script requires one parameter:
#
# $1     the formatted list of domains ready to be installed in the
#        unbound config directory.

ADLISTCFG=/var/unbound/etc/adlist.conf

# ensure parameter is an existing file
[ $# -eq 1 ] || { echo "must supply a filename. exiting"; exit 1; }

CFG="$1"
[ -f "$CFG" ] || { echo "$CFG does not exist. exiting"; exit 1; }

install -o root -g wheel -m 0644 "$CFG" "$ADLISTCFG"

rcctl restart unbound > /dev/null

# an alternative to the above restart is to signal unbound to re-read
# its config files, but not all unbound installations are configured
# with certificates for unbound-control
# unbound-control -q reload
