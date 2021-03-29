#!/bin/bash

apt-get update
apt-get install -y mysql-server

for i in $(grep -n "bind-address" /etc/mysql/mysql.conf.d/mysqld.cnf | cut -d':' -f1); do
    sed -Ei "${i}s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
done

systemctl restart mysql.service

mysql<<EOF
CREATE DATABASE scripts;
CREATE USER 'USUARIO'@'%' IDENTIFIED BY 'SENHA';
GRANT ALL PRIVILEGES ON scripts.* TO 'USUARIO'@'%';
USE scripts;
EOF
