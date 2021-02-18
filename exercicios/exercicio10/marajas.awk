BEGIN {

}

NR > 1 {
    nome = $1
    curso = $2
    salario = $3

    salarios[nome] = salario

    if(cursos[curso] == ""){
        cursos[curso] = nome
    }
    else{ 
        if(salarios[cursos[curso]] < salario){
            cursos[curso] = nome
        }
    }
}

END {
    for (curso in cursos){
        printf "%s: %s, %d\n", curso, cursos[curso], salarios[cursos[curso]] | "sort -nrk3"
    }
}
