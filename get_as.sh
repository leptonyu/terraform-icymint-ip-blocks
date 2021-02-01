#!/bin/bash

set -e
eval "$(jq -r '@sh "NAME=\(.name) KEY_PATH=\(.path)"')"

mkdir -p $KEY_PATH || true

FILE="$KEY_PATH/$NAME.txt"
if [ ! -e "$FILE" ]; then
	whois -h whois.radb.net -- "-i origin $NAME" | grep ^route: | grep -o '[0-9]\+\(\.[0-9]\+\)\{3\}/[0-9]\+' > $FILE
fi

jq -cnM "{ value: \"$(cat $FILE)\" }"