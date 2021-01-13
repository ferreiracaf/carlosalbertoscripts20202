#!/bin/bash

cp /home/compartilhado/atividade04.py ./

sed -Ei 's:/bin/python:/usr/bin/python3:' ./atividade04.py
sed -Ei 's:nota1:NOTA1: ; s:nota2:NOTA2: ; s:notaFinal:NOTAFINAL:' ./atividade04.py
sed -Ei '3a import time' ./atividade04.py
sed -Ei '$a time.ctime()' ./atividade04.py
