#!/bin/bash
# Correção: 1,0

add="adicionar"
show="listar"

if test "$add" = "$1"
then
echo "$2:$3" >> usuarios.db
elif test "$show" = "$1"
then
cat usuarios.db
fi
