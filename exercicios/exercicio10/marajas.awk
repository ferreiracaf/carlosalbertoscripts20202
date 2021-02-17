# Inicialmente achei que era pra colocar os que ganham mais, daí fiz assim... mas vou corrigir! xD

NR > 1 {
    nome = $1
    curso = $2
    salario = $3
    printf "%s: %s, %d\n", curso, nome, salario | "sort -nrk3 | sed -n -e 1p -e 2p -e 3p"
}
