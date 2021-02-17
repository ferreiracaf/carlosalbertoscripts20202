BEGIN {

}

{
    nome = ""
    for (i = 1; i <= (NF - 4); i++){
        nome = nome $i " "
    }

    notas[0] = $(NF-3)
    notas[1] = $(NF-2)
    notas[2] = $(NF-1)
    notas[3] = $(NF)

    for(i = 0; i < 4; i++){
        maior = notas[i] 
        for(j = i +1; j < 4; j++){
            if(notas[j] > maior){
                temp = notas[i]
                notas[i] = notas[j]
                notas[j] = temp
            }
        }
    }

    media = (notas[0]+notas[1]+notas[2])/3
    
    if (media >= 7){
        printf "Aprovado\t%.2f - %s\n", media, nome | "sort -nk2"
    }
    if (media < 7 && media >= 5){
        printf "Final\t\t%.2f - %s\n", media, nome | "sort -nk2"
    }
    if (media < 5){
        printf "Reprovado\t%.2f - %s\n", media, nome | "sort -nk2"
    }
}

END {
    
}