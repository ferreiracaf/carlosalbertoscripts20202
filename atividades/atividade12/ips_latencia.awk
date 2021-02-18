BEGIN {
    print "Relatório de Latência."
}

{
    # se o sistema operacional estiver em inglês: trocar "tempo" por "time" na linha abaixo!
    while(("ping -c 5 " $1 " | grep -E 'tempo=' | cut -d'=' -f4 | sed 's:ms::'") | getline x){
        sum = sum + x
    }
    printf "%s %.2f ms\n", $1, (sum/5)
    sum = 0
}

END {

}