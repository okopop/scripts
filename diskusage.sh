#!/bin/bash
set -eou pipefail
readonly FORMAT="%-8s %-25s %-10s %s\n"
readonly DIRS="/var \
               /opt/puppetlabs \
               /usr"

[[ ! $EUID == 0 ]] && { echo "run as root"; exit 1; }

printf "$FORMAT" SIZE DIRECTORY FINISHED
for dir in ${DIRS[@]}; do
  [[ ! -d $dir ]] && continue
  size=$(du -hsx $dir | awk '{print $1}')
  finished=$(date "+%F %T")
  printf "$FORMAT" $size $dir $finished
done
