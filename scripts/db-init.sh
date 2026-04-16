#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y mysql-server
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql
mysql -u root -e "CREATE DATABASE pfa_db; CREATE USER 'webuser'@'192.168.10.%' IDENTIFIED BY 'PfaSecure2024!'; GRANT ALL PRIVILEGES ON pfa_db.* TO 'webuser'@'192.168.10.%'; FLUSH PRIVILEGES;"
