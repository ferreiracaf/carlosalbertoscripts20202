#!/bin/bash

apt-get install -y mysql-client

USER=USUARIO
PASSWORD=SENHA

echo "[client]
user=carlos
password=$PASSWORD" > /root/.my.cnf

mysql -u $USER scripts -h $PrivateIP<<EOF
CREATE TABLE Teste ( atividade INT );
EOF