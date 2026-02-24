#!/usr/bin/env sh

DIR="$(dirname "$0")"
LOGFILE="$DIR/../logs/dash.log"

rm -Rf "$LOGFILE"
pkill -f "/mnt/us/extensions/TouchDemo/"