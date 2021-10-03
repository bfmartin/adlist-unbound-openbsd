#!/bin/sh
#
# fetch lists of advertising domains
# and format them to include in an unbound config file
#
# the results are sent to STDOUT.

# list of urls for advertising domain names
urls=" \
  https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts \
  https://adaway.org/hosts.txt \
  https://pgl.yoyo.org/adservers/serverlist.php"
# http://winhelp2002.mvps.org/hosts.txt"

trap 'clean_up' EXIT
trap exit HUP INT TERM

TMP1=$(mktemp -q) || exit 1
TMP2=$(mktemp -q) || exit 1

clean_up() { rm -rf "$TMP1" "$TMP2"; }

for i in $urls; do
  # download
  /usr/bin/ftp -o "$TMP1" "$i" > /dev/null

  # whitelist some domains:
  # - kaltura.com for videos from americastestkitchen.com
  # - thepiratebay.org for, um..., stuff
  # - btstatic.com, dpm.demdex.net, and thebrighttag.com for sephora.com login
  grep -vE '#|<|]|:' "$TMP1"   | \
    sed 's/0\.0\.0\.0//'       | \
    sed 's/127\.0\.0\.1//'     | \
    tr -d "\t\r "              | \
    tr '[:upper:]' '[:lower:]' | \
    grep -v localhost          | \
    grep -v localdomain        | \
    grep -v '0.0.0.0'          | \
    sed '/^\s*$/d'             | \
    # whitelist:                 \
    grep -v kaltura.com        | \
    grep -v thepiratebay.org   | \
    grep -v btstatic.com       | \
    grep -v dpm.demdex.net     | \
    grep -v thebrighttag.com     \
    >> "$TMP2"

  rm -f "$TMP1"
done

sort "$TMP2" | uniq | sed "s/.*/local-zone: \"&\" static/"

clean_up
