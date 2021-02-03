#!/bin/bash

read -p "Informe o arquivo: " text

declare -A vet

for i in $(cat $text | tr '.' ' '); do
    if [ "$(echo ${vet[$i]})" == "" ]; then
        vet["$i"]=1
    else
        vet["$i"]=$(echo "${vet[$i]}+1" | bc)
    fi
done

for chave in $(echo ${!vet[@]}); do
    echo -e "$chave:\t${vet[$chave]}"
done
