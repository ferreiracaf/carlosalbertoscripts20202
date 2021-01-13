#!/bin/bash

add="adicionar"
show="listar"
del="remover"

if test "$add" = "$1"
then
    echo "$2:$3" >> usuarios.db
elif test "$show" = "$1"
then
    cat usuarios.db
elif test "$del" = "$1"
then
    # Eu também tinha implementado com o sed, descobria 
    # qual a linha e removia a linha usando o sed, mas 
    # como em mbos não consegui substituir o arquivo 
    # original direto, achei mais sucinto utilizar o grep -v
    grep -v "$2" usuarios.db >> cache.db
    mv cache.db usuarios.db
fi
