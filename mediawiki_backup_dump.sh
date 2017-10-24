#!/bin/bash
# mediawiki content xml dump
# overwrite monthly

PID_CHECK="/usr/sbin/pidof"
PID_NAME="mediawikipidname"
BACKUP_FOLDER="/backup/xmldump"
PHP_CMD="path to php"

DUMP_DATE=$(date +"%F")
DUMP_CMD="path to dumpBackup.php"
DUMP_PARAMETERS=" --full"
DUMP_FILENAME="mediawiki-full-dump"

err () {
    /bin/logger "[ERROR Mediawiki backup] " $@
}

# pre-checks before backup 
$PID_CHECK $PID_NAME >/dev/null || { err "Mediawiki process not started. Content backup aborted"; exit 1; }
[ -d $BACKUP_FOLDER ] || { err "Backup folder is missing. Content backup aborted"; exit 1; } 
[ -f $PHP_CMD ] || { err "PHP is missing. Content backup aborted"; exit 1; } 
[ -f $DUMP_CMD ] || { err "Dump script is missing. Content backup aborted"; exit 1; } 

# execute mediawiki xml dump
$DUMP_CMD $DUMP_PARAMETERS > $DUMP_FILENAME-$DUMP_DATE.xml
