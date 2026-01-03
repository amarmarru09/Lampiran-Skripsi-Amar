#!/bin/bash
MAIN="http://192.168.1.32/webutama"
BACKUP="http://192.168.1.21/webutama"
STATUS=$(curl -Is $MAIN | head -n1 | awk '{print $2}')

if [ "$STATUS" == "200" ]; then
   echo "Main Server OK"
   sed -i 's|ProxyPass .*|ProxyPass '$MAIN'|' /etc/apache2/sites-enabled/000-default.conf
else
   echo "Main Server DOWN - switching to backup"
   sed -i 's|ProxyPass .*|ProxyPass '$BACKUP'|' /etc/apache2/sites-enabled/000-default.conf
fi

systemctl reload apache2
