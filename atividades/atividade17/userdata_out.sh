#!/bin/bash

apt-get install -y mysql-client

USER=alunoufc
PASSWORD=123scripts456

echo "[client]
user=$USER
password=$PASSWORD" > /root/.my.cnf

mysql -u $USER scripts -h $PrivateIP<<EOF
CREATE TABLE Teste ( atividade INT );
EOF
