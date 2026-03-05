#!/bin/bash

ATTACKER_LIST="/var/run/attacker.list"

iptables -t raw -N ATTACKER_RAW 2>/dev/null
iptables -t raw -F ATTACER_RAW

if [ -f "$ATTACKER_LIST" ] && [ -s "$ATTACKER_LIST" ]; then
  while read ip; do
      iptables -t raw -C PREROUTING -s "$ip" -p icmp -j ATTACKER_RAW 2>/dev/null
      iptables -t raw -A PREROUTING -s "$ip" -p icmp -j ATTACKER_RAW
  done < "$ATTACKER_LIST"
fi

iptables -t raw -A ATTACKER_RAW -j DROP

iptables -C INPUT -p tcp --syn -m limit --limit 30/second --limit-burst 60 -j ACCEPT 2>/dev/null || \
iptables -A INPUT -p tcp --syn -m limit --limit 30/second --limit-burst 60 -j ACCEPT

iptables -C INPUT -p tcp --syn -j DROP 2>/dev/null
iptables -A INPUT -p tcp --syn -j DROP

iptables -C INPUT -p icmp -j DROP 2>/dev/null
iptables -C INPUT -p icmp -j DROP 
