#!/bin/bash

IP="$1"

echo "INICIO" >> ./${IP}0.txt

for i in $(seq 0 1 255); do
    ping -c 1 -w 1 "$IP$i" >> ./cache.txt
    if [ $(echo $?) -eq 0 ]; then
        echo -e "$IP$i \ton" >> ./${IP}0.txt
    fi
done

echo "FIM" >> ./${IP}0.txt

rm ./cache.txt