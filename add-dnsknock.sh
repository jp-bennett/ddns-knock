#!/bin/sh
mydomain='<mydomain>'
fwknopFolder='/etc/fwknop'
if [ `grep -c "#$1#" $fwknopFolder/access.conf` -gt 0 ]; then
    printf "this hostname is taken\n"

else
    printf "\n\n#$1#\n" >> $fwknopFolder/access.conf
    printf "SOURCE: ANY\n" >> $fwknopFolder/access.conf
    keys=`fwknopd --key-gen`
    printf "%s\n" "$keys" >> $fwknopFolder/access.conf
    printf 'CMD_CYCLE_OPEN: /usr/local/bin/knock-up.sh %s $SRC\n' "$1" >> $fwknopFolder/access.conf
    printf "CMD_CYCLE_CLOSE: NONE" >> $fwknopFolder/access.conf
    service fwknop reload
    key=`printf "%s" "$keys" | awk -F " " 'FNR == 1 {print $2}'`
    hmac=`printf "%s" "$keys" | awk -F " " 'FNR == 2 {print $2}'`

    printf "\nCommand to update %s.%s:\n" "$1" "$mydomain"
    printf "fwknop -A tcp/22 -s -D ns1.%s --key-base64-rijndael %s --key-base64-hmac %s\n" "$mydomain" "$key" "$hmac"

fi

