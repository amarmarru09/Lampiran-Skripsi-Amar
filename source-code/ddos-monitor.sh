#!/bin/bash

BACKUP_SERVER="192.168.1.21/webutama"
FLAG="/var/www/html/webutama/redirect.flag"

# Threshold untuk deteksi DDoS/Overload
MAX_CPU=80
MAX_LOAD=4
MAX_REQ=200

# Cek CPU usage
CPU=$(awk -F' ' '{print $1}' <(grep 'cpu ' /proc/stat))
sleep 1
CPU2=$(awk -F' ' '{print $1}' <(grep 'cpu ' /proc/stat))
CPU_USAGE=$(( 100 * (CPU2 - CPU) / 100000 ))

# Cek Load average
LOAD=$(awk '{print $1}' /proc/loadavg | cut -d. -f1)

# Cek Apache requests (port 80 connections)
REQ=$(ss -tuna | grep ":80" | wc -l)


# Jika overload → aktifkan redirect
if [ $CPU_USAGE -gt $MAX_CPU ] || [ $LOAD -gt $MAX_LOAD ] || [ $REQ -gt $MAX_REQ ]; then
    echo "DDoS Detect at: $(date)" > $FLAG
    exit
fi

# Jika kondisi normal → matikan redirect
if [ -f "$FLAG" ]; then
    rm "$FLAG"
fi



