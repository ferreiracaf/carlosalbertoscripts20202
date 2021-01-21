#!/bin/bash
# Correção: 1,0

arquivo="$1"

if [ -f "$arquivo" ]
then
    echo "É um arquivo."
elif [ -d "$arquivo" ]
then
    echo "É uma pasta."
fi

if [ -r "$arquivo" ]
then
    echo "Tem permissão de leitura."
else
    echo "Não tem permissão de leitura."
fi

if [ -w "$arquivo" ]
then
    echo "Tem permissão de escrita."
else
    echo "Não tem permissão de escrita."
fi
