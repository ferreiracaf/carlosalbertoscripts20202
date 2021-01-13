#!/bin/bash

file="$1"
test=0
file_res="ips_classificados.txt"

rm $file_res

echo "Endereços válidos:" >> $file_res
echo "" >> $file_res
echo "Endereços inválidos:" >> $file_res

for line in $(cat $file); 
do 
    OLDIFS=${IFS}
    IFS="."

    for number in $line;
    do 
        if [ $number -lt 0 -o $number -gt 255 ]
        then
            test=1
            break
        fi;
    done;

    IFS={OLDIFS}

    if [ $test -eq 1 ] 
    then
        #coloca como invalido
        echo $line >> $file_res
        test=0
    else
        #coloca como valido
        sed -Ei "2a ${line}" $file_res
    fi
done

