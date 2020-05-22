#!/bin/bash
set -eou pipefail
readonly FORMAT="%-10s %s %5s  %s\n"
readonly DIRS="/var \
               /opt/puppetlabs \
               /usr"

[[ ! $EUID == 0 ]] && { echo "run as root"; exit 1; }

#printf "$FORMAT" SIZE DIRECTORY TIME
# shellcheck disable=SC2068
for dir in ${DIRS[@]}; do
  [[ ! -d $dir ]] && continue
  size=$(du -hsx "$dir" | awk '{print $1}')
  f_time=$(date "+%F %T")
  # shellcheck disable=SC2059
  printf "$FORMAT" "$f_time" "$size" "$dir"
done
