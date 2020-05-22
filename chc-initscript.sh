#! /bin/sh
### BEGIN INIT INFO
# Provides: CHCD
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: CHCD
# Description: This file starts and stops CHCD server
### END INIT INFO

CHCD_DIR=x
CHCD_USER=x
CHCD_CONF_DIR=x

case "$1" in
 start)
   /bin/pidof chaincoind >/dev/null && { echo "chaincoind already started"; exit 1; }
   su $CHCD_USER -c "$CHCD_DIR/chaincoind --conf=$CHCD_CONF_DIR/chaincoin.conf --daemon"
   echo "Wait for the service to start, it takes a couple of seconds"

   # wait for daemon to start then show info
   $0 status 2>/dev/null
   # shellcheck disable=SC2181
   while [ $? -ne 0 ]; do
       # shellcheck disable=SC2039
       echo -n "."
       sleep 1
       $0 status 2>/dev/null
   done
   # start masternode
   su $CHCD_USER -c "$CHCD_DIR/chaincoind masternode start"
   ;;
 stop)
   /bin/pidof chaincoind >/dev/null || { echo "chaincoind not started"; exit 1; }
   su $CHCD_USER -c "$CHCD_DIR/chaincoind stop"
   sleep 3
   ;;
 status)
   /bin/pidof chaincoind >/dev/null || { echo "chaincoind not started"; exit 1; }
   su $CHCD_USER -c "$CHCD_DIR/chaincoind getinfo"
   ;;
 restart)
   $0 stop
   echo "Sleeping 10 sec before starting again..."
   sleep 10
   $0 start
   ;;
 *)
   echo "Usage: sudo $0 {start|stop|status|restart}" >&2
   exit 3
   ;;
esac
