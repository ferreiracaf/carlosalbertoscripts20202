#!/bin/bash
# Correção: 3,0

interval=$1
dir=$2

[ ! -d $dir ] && echo "O diretório não existe" && exit 1

cache_old=".cache.old.db"
cache_new=".cache.new.db"
cache_print=".cache.print.db"

[ -f  dirSensors.log ] && rm  dirSensors.log
[ -f $cache_old ] && rm $cache_old
[ -f $cache_new ] && rm $cache_new

old_qtd=$(ls $dir | wc -l)

ls $dir > $cache_old

while true; do
    new_qtd=$(ls $dir | wc -l)
    ls $dir > $cache_new

    # se a quantidade anterior é menor que a atual = ADICIONADO
    if [ $old_qtd -lt $new_qtd ]; then
        for i in $(cat $cache_new); do
            flag=0
            for j in $(cat $cache_old); do
                if [ $i == $j ]; then
                    flag=1
                fi
            done
            if [ $flag == 0 ]; then
                echo $i >> $cache_print
            fi
        done
        print="$(cat $cache_print | tr '\n' '+' | sed "s:+:, :g" | rev | cut -d',' -f2- | rev)"
        rm $cache_print
        echo "[$(date '+%d-%m-%Y %H:%M:%S')] Alteração! $old_qtd->$new_qtd. Adicionados: $print" >>  ./dirSensors.log

    # se a quantidade anterior é maior que a atual
    elif [ $old_qtd -gt $new_qtd ]; then
        
        for i in $(cat $cache_old); do
            flag=0
            for j in $(cat $cache_new); do
                if [ $i == $j ]; then
                    flag=1
                fi
            done
            if [ $flag == 0 ]; then
                echo $i >> $cache_print
            fi
        done
        print="$(cat $cache_print | tr '\n' '+' | sed "s:+:, :g" | rev | cut -d',' -f2- | rev)"
        rm $cache_print        
        echo "[$(date '+%d-%m-%Y %H:%M:%S')] Alteração! $old_qtd->$new_qtd. Removidos: $print" >> dirSensors.log
    fi
    
    old_qtd=$new_qtd
    cat $cache_new > $cache_old
    
    sleep $interval
done
