#!/usr/bin/env sh

DIR="$(dirname "$0")"
LOG_FILE="$DIR/../logs/touchdemo.log"

mkdir -p "$(dirname "$LOG_FILE")"

"$DIR/$1" >>"$LOG_FILE" 2>&1