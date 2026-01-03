#!/bin/bash

ALERT="/var/log/snort/snort.alert.fast"
BACKUP_IP="192.168.1.21"

tail -Fn0 $ALERT | while read line; do
  if echo "$line" | grep -i "DoS\|DDoS\|SYN"; then
    IP=$(echo $line | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)

    if [ ! -z "$IP" ]; then
      iptables -t nat -C PREROUTING -s $IP -p tcp --dport 80 -j DNAT --to-destination $BACKUP_IP 2>/d>
      iptables -t nat -A PREROUTING -s $IP -p tcp --dport 80 -j DNAT --to-destination $BACKUP_IP

      echo "$(date) - Redirect attacker $IP to $BACKUP_IP" >> /var/log/auto-redirect.log
    fi
  fi
done
