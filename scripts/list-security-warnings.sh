#!/bin/sh

docker scan --accept-license litecoin:0.18.1 | grep Description: | awk '{first = $1; $1 = ""; print $0; }' | uniq | sed 's/^ //g'
