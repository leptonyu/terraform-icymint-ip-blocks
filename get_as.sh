#!/bin/bash

set -e
eval "$(jq -r '@sh "NAME=\(.name) KEY_PATH=\(.path)"')"

mkdir -p $KEY_PATH || true

FILE="$KEY_PATH/$NAME.txt"
if [ ! -e "$FILE" ]; then
	whois -h whois.radb.net -- "-i origin $NAME" | grep ^route: | grep -o '\d\+\(\.\d\+\)\{3\}/\d\+' > $FILE
fi

jq -cnM "{ value: \"$(cat $FILE)\" }"