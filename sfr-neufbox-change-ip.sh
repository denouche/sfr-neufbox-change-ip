#!/bin/bash

CREDENTIALS=".credentials"
IP="192.168.1.1"
LIBS="./libs"
PHANTOM="$LIBS/phantomjs-1.9.7-linux-x86_64/bin/phantomjs"
TMP="./tmp"
COOKIES_FILE="$TMP/cookies"
GET_IP_URL="http://ipecho.net/plain"
TEMPLATES_DIR="./templates"
FILE_HASH="getHash.js"
FILE_WAN_LOGIN="getCurrentWanLogin.js"
FILE_WAN_PASSWORD="getCurrentWanPassword.js"


getCurrentIp ()
{
    wget -q -O - $GET_IP_URL
}

waitfor () 
{
    LIMIT=$1
    i=0
    while [ $i -lt $LIMIT ]
    do
        echo -n '.'
        sleep 1
        i=$((i+1))
    done
}

copyAndReplaceTemplate()
{
    FILE="$TMP/$1"
    cp $TEMPLATES_DIR/$1.tpl $FILE
    sed -i 's/%%IP%%/'$IP'/' $FILE
    sed -i 's/%%challenge%%/'$ZSID'/' $FILE
    sed -i 's/%%login%%/'$WEBLOGIN'/' $FILE
    sed -i 's/%%password%%/'$WEBPASS'/' $FILE
}

clean()
{
    rm -rf $TMP/
}

init()
{
    if [ -e $CREDENTIALS ]
    then
        WEBLOGIN="$(cat $CREDENTIALS | cut -d: -f1)"
        WEBPASS="$(cat $CREDENTIALS | cut -d: -f2)"
    else
        echo -e "Error: Missing $CREDENTIALS file.\nThis file have to contains login and password used to connect on the web interface.\nFormat of this file is:\nlogin:password"
        exit 1
    fi
    
    mkdir -p $TMP
}

main()
{
    clean
    init

    echo "Current IP is $(getCurrentIp)"
    
    echo -n "Authenticating..."
    wget -q -O /dev/null \
         --keep-session-cookies --save-cookies=$COOKIES_FILE \
         --referer=http://$IP/login \
         --post-data='action=challenge' \
         --header='Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
         --header='X-Requested-With: XMLHttpRequest' \
         http://$IP/login
    
    ZSID=$(cat $COOKIES_FILE | grep sid | cut -f7)
    
    copyAndReplaceTemplate $FILE_HASH
    HASH=$($PHANTOM $TMP/$FILE_HASH)

    POST_AUTH="method=passwd&page_ref=&zsid=$ZSID&hash=$HASH&login=&password="

    wget -q -O /dev/null \
         --load-cookies $COOKIES_FILE \
         --referer=http://$IP/login \
         --post-data="$POST_AUTH" \
         --header='Content-Type: application/x-www-form-urlencoded' \
         http://$IP/login
    
    echo "OK"
    
    copyAndReplaceTemplate $FILE_WAN_LOGIN
    WAN_LOGIN=$($PHANTOM $TMP/$FILE_WAN_LOGIN)
    
    copyAndReplaceTemplate $FILE_WAN_PASSWORD
    WAN_PASSWORD=$($PHANTOM $TMP/$FILE_WAN_PASSWORD)
    
    echo -n "Changing IP."

    wget -q -O /dev/null \
         --load-cookies $COOKIES_FILE \
         --referer=http://$IP/network/wan \
         --post-data="action=form_ppp&ppp_login=$WAN_LOGIN&ppp_password=WRONG$WAN_PASSWORD&submit=" \
         --header='Content-Type: application/x-www-form-urlencoded' \
         http://$IP/network/wan
    
    waitfor 10
    
    wget -q -O /dev/null \
         --load-cookies $COOKIES_FILE \
         --referer=http://$IP/network/wan \
         --post-data="action=form_ppp&ppp_login=$WAN_LOGIN&ppp_password=$WAN_PASSWORD&submit=" \
         --header='Content-Type: application/x-www-form-urlencoded' \
         http://$IP/network/wan > /dev/null
    
    
    waitfor 10
    
    echo "OK"
    echo "New IP is $(getCurrentIp)"

    clean
}

main

