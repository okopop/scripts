#!/bin/bash
set -euo pipefail
CHC_COUNT=$1
CHC_TO_SEND=$(( CHC_COUNT - 1000 ))
echo "$CHC_COUNT is current count"

if [ $CHC_TO_SEND -ge "1" ]; then
  echo "send_cmd chc=$CHC_TO_SEND"
  echo "Write this to LOGFILE -> $(date +"[%F %T]") send_cmd chc=$CHC_TO_SEND"
else
  echo "No leftover chc to send"
  exit 1
fi
