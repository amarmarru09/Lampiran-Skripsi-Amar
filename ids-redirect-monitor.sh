#!/bin/bash

LOGFILE="/var/log/snort/snort.alert.fast"
REDIRECT_IP="192.168.1.21/webutama"   # bisa kamu ganti ke IP lain
PORT="80"

# pattern alert yang mau dipakai (NANTI ganti ke pesan rule DDoS-mu)
PATTERN="BAD-TRAFFIC same SRC/DST"

echo "[IDS-REDIRECT] Monitoring $LOGFILE for pattern: $PATTERN"

tail -Fn0 "$LOGFILE" | while read line; do
    # cek apakah baris ini mengandung alert yang kita mau
    if echo "$line" | grep -q "$PATTERN"; then
        echo "[IDS-REDIRECT] Alert matched: $line"

        # ambil IP sumber (field setelah {UDP}/{TCP}/{IPV6-ICMP})
        SRC_IP=$(echo "$line" | awk '{
            for (i=1;i<=NF;i++) {
                if ($i=="{UDP}" || $i=="{TCP}" || $i=="{IPV6-ICMP}") {
                    split($(i+1), a, ":");
                    print a[1];
                    break;
                }
            }
        }')

        # kalau gagal ambil IP, skip
        if [ -z "$SRC_IP" ]; then
            echo "[IDS-REDIRECT] Failed to parse source IP from line"
            continue
        fi

        echo "[IDS-REDIRECT] Detected attacker IP: $SRC_IP"

        # cek apakah rule sudah ada biar nggak dobel
        if iptables -t nat -C PREROUTING -s "$SRC_IP" -p tcp --dport $PORT -j DNAT --to-destination $>
            echo "[IDS-REDIRECT] Rule already exists for $SRC_IP, skipping"
        else
            iptables -t nat -A PREROUTING -s "$SRC_IP" -p tcp --dport $PORT -j DNAT --to-destination >
            echo "$(date) - Redirected $SRC_IP to $REDIRECT_IP" >> /var/log/redirect.log
            echo "[IDS-REDIRECT] Added redirect rule for $SRC_IP"
        fi
    fi
done
