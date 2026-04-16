#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y apache2 libapache2-mod-security2 modsecurity-crs mysql-client

# Activation WAF
cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf

# Activation règles OWASP
cat >> /etc/apache2/mods-enabled/security2.conf << EOF
<IfModule security2_module>
    IncludeOptional /usr/share/modsecurity-crs/*.conf
    IncludeOptional /usr/share/modsecurity-crs/rules/*.conf
</IfModule>
EOF

systemctl restart apache2
echo "<h1>Zone DMZ - Protegee par WAF</h1>" > /var/www/html/index.html
