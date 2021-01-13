#!/bin/bash

path="$1"

if [ -d "$path" ]
then  
    size=$(du -sk ${path} | cut -f1)
    qtd=$(ls | wc -l)
    echo "O diretório ${path} ocupa ${size} kilobytes e tem ${qtd} itens."

else
    echo "${path} não é um diretório!!!"
fi