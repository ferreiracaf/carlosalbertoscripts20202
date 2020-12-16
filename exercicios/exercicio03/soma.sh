#!/bin/bash
# Correção: OK
cat compras.txt | cut -d " " -f 2 | tr "[:space:]" "+" | sed 's/+$/\n/' | bc
