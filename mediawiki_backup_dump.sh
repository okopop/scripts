#!/bin/bash
# mediawiki content xml dump. monthly rotation 
# tested on centos/rhel

PID_CHECK="/usr/sbin/pidof"
PID_NAME="mediawikipidname"
HTTP_URL="https://www.google.se/"
HTTP_STATUS=$(curl -s -o /dev/null -I -w "%{http_code}" $HTTP_URL)
BACKUP_FOLDER="/tmp/mw/backup/content-dump/"
PHP_CMD="/tmp/mw/php"

DUMP_DATE=$(date +"%d")
DUMP_CMD="/tmp/mw/dumpBackup.php"
DUMP_PARAMETERS="--full"
DUMP_FILENAME="mediawiki-full-dump"

err () {
    /usr/bin/logger "[ERROR Mediawiki backup]" $@
    exit 1
}

# pre-checks before backup 
if [ "$HTTP_STATUS" -ne "200" ]; then err "Http address not reachable. Content backup aborted"; fi
$PID_CHECK $PID_NAME >/dev/null || err "Mediawiki process not started. Content backup aborted"
[ -d $BACKUP_FOLDER ] || err "Backup folder is missing. Content backup aborted" 
[ -f $PHP_CMD ] || err "PHP is missing. Content backup aborted"
[ -f $DUMP_CMD ] || err "Dump script is missing. Content backup aborted" 

# execute mediawiki xml dump
# php dumpBackup.php --full > dump.xml
$PHP_CMD $DUMP_CMD $DUMP_PARAMETERS > $BACKUP_FOLDER$DUMP_FILENAME-$DUMP_DATE.xml

if [ $? -eq "0" ]; then
    /usr/bin/logger "[INFO Mediawiki backup] Content xml dump was successful: $BACKUP_FOLDER$DUMP_FILENAME-$DUMP_DATE.xml"
else
    err "Execution of dump command failed"
fi
