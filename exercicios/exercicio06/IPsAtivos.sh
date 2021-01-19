#!/bin/bash
IP=$1

echo "Iniciando análise da rede ${IP}0/24."
echo "O resultado estará em ${IP}0.txt"
./IPsAtivos.sh $IP & 