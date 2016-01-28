#!/bin/sh
#nsupdate wrapper script
#takes two arguments, a hostname and an IP address
#looks up the current IP of the given host, if they match, exits
#if they differ, uses nsupdate to delete and add the hostname with the new IP
#intended to be run using fwknop and the new CMD_OPEN mode.
#In that case, any machine on the network could run fwknop on a cron task to keep the IP up to date.
mydomain='<mydomain>'

nslookup $1.$mydomain

exists=`nslookup $1.$mydomain 127.0.0.1 | grep -c $2`
echo $exists

if [ $exists -eq 0 ] ; then

printf 'update delete %s.%s A\nupdate add %s.%s 60 A %s\nsend\n' "$1" "$mydomain" "$1" "$mydomain" "$2" | nsupdate -k /etc/named/K$mydomain.*.private

fi
