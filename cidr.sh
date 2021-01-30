#!/bin/bash
set -e
eval "$(jq -r '@sh "VAL=\(.value)"')"

jq -cnM "{ value: \"$(echo "$VAL" | grep '[0-9]' | cidr)\" }"