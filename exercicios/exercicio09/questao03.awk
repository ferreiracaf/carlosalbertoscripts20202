BEGIN {

}

{
    split($NF, alias, "@")
    printf "%s@alu.ufc.br\n", alias[1];
}

END {

}