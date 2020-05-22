#!/bin/bash
# mediawiki content xml dump. monthly rotation
# tested on rhel7
set -euo pipefail

readonly PID_CHECK="/usr/sbin/pidof"
readonly PID_NAME="/usr/libexec/mysqld"
readonly PHP_CMD="/bin/php"
readonly HTTP_URL="localhost:443"
readonly HTTP_STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" $HTTP_URL)
readonly BACKUP_FOLDER="/x/"
 
readonly DUMP_DATE=$(date +"%d")
readonly DUMP_CMD="/var/www/mediawiki/maintenance/dumpBackup.php"
readonly DUMP_PARAMETERS="--quiet --full"
readonly DUMP_FILENAME="mediawiki-full-dump"
 
err () {
  /bin/logger -t "[ERROR] Mediawiki backup" "$@"
  exit 1
}
 
# pre-checks before backup
if [[ "$HTTP_STATUS" -ne "200" ]]; then err "Http address not reachable. Content backup aborted"; fi
$PID_CHECK $PID_NAME >/dev/null || err "MariaDB process not started. Content backup aborted"
[[ -d $BACKUP_FOLDER ]] || err "Backup folder is missing. Content backup aborted"
[[ -f $PHP_CMD ]] || err "PHP is missing. Content backup aborted"
[[ -f $DUMP_CMD ]] || err "Dump script is missing. Content backup aborted"
 
# execute mediawiki xml dump (php dumpBackup.php --full > dump.xml)
${PHP_CMD} ${DUMP_CMD} ${DUMP_PARAMETERS} > ${BACKUP_FOLDER}${DUMP_FILENAME}-${DUMP_DATE}.xml
/bin/gzip -f ${BACKUP_FOLDER}${DUMP_FILENAME}-${DUMP_DATE}.xml
 
if [ $? -eq "0" ]; then
  /bin/logger -t "[INFO] Mediawiki backup" "Content xml dump was successful: \
                 ${BACKUP_FOLDER}${DUMP_FILENAME}-${DUMP_DATE}.xml"
else
  err "Execution of dump command failed"
fi
