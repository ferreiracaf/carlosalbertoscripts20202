#!/bin/bash
trap "clear;echo -e \"\nAté a próxima $(whoami)\";exit" 2

opcao=

menu() {
    echo "Informe a opcao"
    echo "1 - Tempo ligado" #(uptime)
    echo "2 - Últimas Mensagens do Kernel" #(dmesg | tail -n 10)
    echo "3 - Memória Virtual" #(vmstat 1 10)
    echo "4 - Uso da CPU por núcleo" #(mpstat -P ALL 1 5)
    echo "5 - Uso da CPU por processos" #(pidstat 1 5)
    echo "6 - Uso da Memória Física" #(free -m)
}

func1(){
    uptime
}

func2(){
    dmesg | tail -n 10
}

func3(){
    vmstat 1 10
}

func4(){
    mpstat -P ALL 1 5
}

func5(){
    pidstat 1 5
}

func6(){
    free -m
}

while true; do
    # clear
    echo ""
    menu
    read -p "-> " opcao
    if [ $opcao == '1' ]; then
        func1
    elif [ $opcao == '2' ]; then
        func2
    elif [ $opcao == '3' ]; then
        func3
    elif [ $opcao == '4' ]; then
        func4
    elif [ $opcao == '5' ]; then
        func5
    elif [ $opcao == '6' ]; then
        func6
    else
        echo "Opção inválida"
    fi

    echo ""
    read -p "Tecle enter para continuar!"
done