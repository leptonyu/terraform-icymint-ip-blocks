#!/bin/bash

set -e
eval "$(jq -r '@sh "KEY_PATH=\(.path)"')"

jq -cnM "{ value: \"$(cat $KEY_PATH | cidr)\" }"