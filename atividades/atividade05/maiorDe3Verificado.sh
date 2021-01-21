#!/bin/bash
# Correção: 1,0
maior="$1"
regex='^[0-9]+$'

for i 
do
    if ! [[ ${i} =~ $regex ]]
    then
        echo "Opa!!! ${i} não é número."
        exit 1
    elif [ ${i} -gt ${maior} ]
    then
        maior=${i}
    fi;
done

echo $maior
