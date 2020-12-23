#!/bin/bash

add="adicionar"
show="listar"

if test "$add" = "$1"
then
echo "$2:$3" >> usuarios.db
elif test "$show" = "$1"
then
cat usuarios.db
fi
