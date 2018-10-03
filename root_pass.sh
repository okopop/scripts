#!/bin/bash
# generate root password, create gpg file and set root password locally

GPG_SRV=centos1
VERBOSE=0

usage() {
echo "Usage: $0 -s SERVERNAME 
  -s, servername
  -v, verbose
  -h, help" 
exit 1
}

while getopts :hvs: arg; do
  case $arg in
    h)
      usage
      ;;
    s)
      SERVERNAME=$OPTARG
      ;;
    v)
      VERBOSE="1"
      ;;
    *)
      usage
      ;;
  esac
done

if [ $# -eq 0 ] || [ ! "$SERVERNAME" ]; then
    usage
fi

# main code
HASHEDPASS=$(ssh root@$GPG_SRV sh genpassword.sh | ( read genpassword; openssl passwd -1 -salt xyz $genpassword))
echo "Generated password and create gpg file on $GPG_SRV then set root password locally on $SERVERNAME"
if [ $VERBOSE -eq "1" ]; then
    echo "Set root password hash: $HASHEDPASS"
fi
