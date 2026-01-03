#!/bin/bash

FLAG="/var/www/html/webutama/redirect.flag"

if systemctl is-active --quiet apache2; then
    rm -f $FLAG
else
    touch $FLAG
fi

