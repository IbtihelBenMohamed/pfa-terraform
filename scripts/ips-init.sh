#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y suricata iptables-persistent

# Configuration IPS via NFQUEUE (pour intercepter le trafic du firewall)
iptables -I FORWARD -j NFQUEUE --queue-num 0

# Ajout des règles locales
cat > /etc/suricata/rules/local.rules << 'RULES'
# 1. Scan de ports
alert tcp any any -> \$HOME_NET any (msg:"Scan de ports detecte"; flags:S; threshold:type threshold, track by_src, count 20, seconds 10; sid:1000001; rev:1;)
# 2. Brute-force SSH
alert tcp any any -> \$HOME_NET 22 (msg:"Tentative brute-force SSH"; threshold:type threshold, track by_src, count 5, seconds 60; sid:1000002; rev:1;)
# 3. Injection SQL
alert http any any -> \$HTTP_SERVERS any (msg:"Injection SQL detectee"; content:"UNION SELECT"; nocase; sid:1000003; rev:1;)
# 4. DoS HTTP
alert tcp any any -> \$HOME_NET 80 (msg:"Attaque DoS HTTP"; threshold:type threshold, track by_src, count 100, seconds 10; sid:1000004; rev:1;)
RULES

# Activer les règles locales dans la config Suricata
if ! grep -q "local.rules" /etc/suricata/suricata.yaml; then
  sed -i '/rule-files:/a\  - local.rules' /etc/suricata/suricata.yaml
fi

systemctl enable suricata
systemctl restart suricata
