#!/bin/bash

tmp1=testgetrequest.xml
tmp2=test2.txt

echo "
XML INPUT
========="
xml fo "$tmp1"
echo; echo

# xml sel -t -m effectiveRequests/effectiveRequest \
# -o "  AGT_LESS=" -v 'agent[@type="None"]/node/name' \
# -o "  AGT_LOCAL=" -v 'agent[@type="Local"]/node/name' \
# -o "  AGT_REMOTE=" -v 'agent[@type="Remote"]/node/name' \
# -o "  module=" -v module \
# -o "  functn=" -v function \
# -o "  frqprd=" -v frequency/period \
# -o "  retention=" -v retention \
# -n "$tmp1" > "$tmp2"

# xml sel -C -t -m effectiveRequests/effectiveRequest -v "@agent" -n "$tmp1" > "$tmp2"
xml sel -t -m effectiveRequests/effectiveRequest -o "AGENT=" -v "@agent" -n "$tmp1" > "$tmp2"

cat "$tmp2" | grep -i [0-9,a-z] | awk '{print NR"    "$0}'

echo; echo
rm -rf "$tmp2"
