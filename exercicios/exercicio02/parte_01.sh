#!/bin/bash
# Correção: 0,8. Faltou apenas alguma tentativa sobre o IP na segunda parte.

grep -E '[[:digit:]]{6}[[:space:]]*A' /home/compartilhado/emailsordenados.txt #1

grep -E "\<A" /home/compartilhado/emailsordenados.txt #2

grep -E ".br\>" /home/compartilhado/emailsordenados.txt #3

grep -E "[[:alpha:]]*[[:digit:]]+[[:alpha:]]*@" /home/compartilhado/emailsordenados.txt #4

