#!/bin/sh
#
# call this script via crontab, like this:
#
#   0 1 * * 0 /usr/local/bin/adlist-unbound-cron.sh
#
# 

SCRIPTNAME=$(readlink -f "$0")
MEDIR=$(dirname "$SCRIPTNAME")

trap 'clean_up' EXIT
trap exit HUP INT TERM
clean_up() { rm -rf "$TMPFILE"; }

TMPFILE=$(mktemp)
"$MEDIR"/adlist-unbound-fetch.sh > "$TMPFILE"
/usr/bin/doas "$MEDIR"/adlist-unbound-ctl.sh "$TMPFILE"

clean_up
