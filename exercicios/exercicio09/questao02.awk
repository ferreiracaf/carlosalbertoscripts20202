#Correção: OK
BEGIN {
    soma=0
}

$NF ~ /@gmail.com$/ {
    soma = soma + 1
}

END {
    print soma
}