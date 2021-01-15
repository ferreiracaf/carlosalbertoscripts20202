#!/bin/bash

echo "Relatório de Latência."

for i in $(cat $1); do
    sum="($(ping ${i} -c 5 | grep -E "time=" | cut -d'=' -f4 | sed "s:ms:+:" | tr '\n' ' ' | rev | cut -c 3- | rev))"
    avg=$(echo "scale=3; $sum/5" | bc -l)
    echo "${i} ${avg}.ms"
done
