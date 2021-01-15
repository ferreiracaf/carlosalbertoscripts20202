#!/bin/bash

# Dica de teste: usando o comando abaixo move apenas o arquivo 4 do diretorio 1 para o diretorio 2
# ./backupIncremental.sh dir1 dir2 2021-01-15 09:35:50

dir1="$1"
dir2="$2"
date=$(date -d "$3 $4" +%s)
flag=0

if [ $# -eq 2 ]; then
    for file1 in $(ls dir1); do
        for file2 in $(ls dir2); do
            if [ $file1 == $file2 ]; then
                flag=1
                break
            fi
        done
        if [ $flag -eq 0 ]; then
            cp $dir1/$file1 $dir2
        fi
        flag=0
    done
elif [ $# -eq 4 ]; then
    for file1 in $(ls dir1); do
        file_date=$(date -d "$(stat ${dir1}/${file1} | grep -E "Modi" | cut -d' ' -f2- | cut -d'.' -f1)" +%s)
        if [ $file_date -gt $date ]; then
            for file2 in $(ls dir2); do
                if [ $file1 == $file2 ]; then
                    flag=1
                    break
                fi
            done
            if [ $flag -eq 0 ]; then
                cp $dir1/$file1 $dir2
            fi
            flag=0
        fi
    done
else
    echo "Invalid amount of arguments"
fi


