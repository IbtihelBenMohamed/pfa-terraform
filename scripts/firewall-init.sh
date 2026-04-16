#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
systemctl stop ufw
systemctl disable ufw
systemctl mask ufw

apt-get update -y
apt-get install -y nftables

echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-sysctl.conf
sysctl -p /etc/sysctl.d/99-sysctl.conf

# Détection auto des interfaces (Ordre : External, DMZ, Privé, Monitoring)
INTERFACES=$(ls /sys/class/net | grep -v lo | sort)
IF_EXT=$(echo $INTERFACES | awk '{print $1}')
IF_DMZ=$(echo $INTERFACES | awk '{print $2}')
IF_PRIV=$(echo $INTERFACES | awk '{print $3}')
IF_MON=$(echo $INTERFACES | awk '{print $4}')

cat > /etc/nftables.conf << NFTEOF
#!/usr/sbin/nft -f
flush ruleset
table inet filter {
    chain input {
        type filter hook input priority 0; policy drop;
        ct state established,related accept
        iifname "lo" accept
        tcp dport 22 accept
        icmp type echo-request accept
    }
    chain forward {
        type filter hook forward priority 0; policy drop;
        ct state established,related accept
        iifname "$IF_EXT" oifname "$IF_DMZ" ip daddr 192.168.10.0/24 tcp dport { 80, 443 } accept
        iifname "$IF_DMZ" oifname "$IF_PRIV" ip saddr 192.168.10.0/24 ip daddr 192.168.20.0/24 tcp dport 3306 accept
        iifname "$IF_DMZ" oifname "$IF_MON" accept
        iifname "$IF_MON" oifname "$IF_DMZ" accept
        tcp dport 22 accept
    }
    chain output { type filter hook output priority 0; policy accept; }
}
table ip nat {
    chain prerouting {
        type nat hook prerouting priority -100;
        iifname "$IF_EXT" tcp dport 80 dnat to 192.168.10.10
    }
    chain postrouting {
        type nat hook postrouting priority 100;
        oifname "$IF_EXT" masquerade
    }
}
NFTEOF

chmod 755 /etc/nftables.conf
systemctl enable nftables
systemctl restart nftables
