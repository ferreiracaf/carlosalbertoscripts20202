#!/bin/bash

dir1="$1"
dir2="$2"
equal=0

for file1 in $(ls dir1); 
do
    for file2 in $(ls dir2);
    do
        if [ $file1 == $file2 ]
        then
            echo $file1 $file2
            equal=1
            break
        else
            echo $file1 $file2
        fi
    done
    
    if [ $equal -eq 0 ]
    then
        cp $dir1/$file1 $dir2
    fi;
    equal=0
done