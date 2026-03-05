#!/bin/bash

SNORT_ALERT="/var/log/snort/alert"
ATTACKER_LIST="/ar/run/attacker.list"

grep -- "->" "SNORT_ALERT" \
| awk '{print $2}' \
| cut -d':' -f \
| sort -u > "$ATTACKER_LIST"
