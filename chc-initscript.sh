### BEGIN INIT INFO
# Provides: CHCD
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: CHCD
# Description: This file starts and stops CHCD server
#
### END INIT INFO

CHCD_DIR=x
CHCD_USER=x
CHCD_CONF_DIR=x

case "$1" in
 start)
   su $CHCD_USER -c "$CHCD_DIR/chaincoind --conf=$CHCD_CONF_DIR/chaincoin.conf --daemon"
   echo "This takes a couple of seconds, please wait"
   ;;
 stop)
   /bin/pidof chaincoind >/dev/null || echo "chaincoind not started"
   su $CHCD_USER -c "$CHCD_DIR/chaincoind stop"
   ;;
 status)
   /bin/pidof chaincoind >/dev/null || echo "chaincoind not started"
   su $CHCD_USER -c "$CHCD_DIR/chaincoind getinfo"
   ;;
 restart)
   $0 stop
   echo "Sleeping 15 sec before starting again..."
   sleep 15
   $0 start
   ;;
 *)
   echo "Usage: CHCD {start|stop|status|restart}" >&2
   exit 3
   ;;
esac
