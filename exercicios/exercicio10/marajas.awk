BEGIN {

}

NR > 1 {
    nome = $1
    curso = $2
    salario = $3
    printf "%s: %s, %d\n", curso, nome, salario | "sort -nrk3 >> a.txt"
    print "teste" | "awk 'NR < 4 {print}' a.txt"
    print "teste" | "rm a.txt"
}

END {

}