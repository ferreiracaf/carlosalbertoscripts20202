BEGIN {
    FS=":"
}

{
    sub("/home/alunos", "/srv/students", $6)
    print > "passwd.new"
}

END {

}