#!/bin/bash

apt-get update
apt-get install -y mysql-client

echo "[client]
user=USUARIO
password=SENHA" > /root/.my.cnf

mysql --defaults-file=/root/.my.cnf -u USUARIO scripts -h PRIVADOIP<<EOF
CREATE TABLE Teste ( atividade INT );
EOF
