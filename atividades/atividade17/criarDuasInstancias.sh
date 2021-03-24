#!/bin/bash

KEY=$1
USER=$2
PASSWORD=$3
MYIP=$(curl ifconfig.me)
IMAGE="ami-042e8287309f5df03"
GroupName="SGIDScriptsAtividade17"
SUBNET=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
VPCID=$(aws ec2 describe-subnets --query "Subnets[0].VpcId" --output text)
createSG=1

for i in $(aws ec2 describe-security-groups --query "SecurityGroups[].GroupName" --output text)
do
    if [[ $i == $GroupName ]]; then
        createSG=0
    fi
done

if [ $createSG -eq 1 ]; then
    SGID=$(aws ec2 create-security-group --group-name $GroupName --description "$GroupName description" --vpc-id $VPCID --output text)
    aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 22 --cidr $MYIP/32
    aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 80 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 3306 --source-group $SGID
else
    SGID=$(aws ec2 describe-security-groups --group-name $GroupName --query "SecurityGroups[0].GroupId" --output text)
fi

sed -e "s/USUARIO/$USER/" ./userdatadb.sh > ./userdatadb_out.sh
sed -Ei "s/SENHA/$PASSWORD/" ./userdatadb_out.sh

echo "Criando servidor de Banco de Dados..."

InstanceId1=$(aws ec2 run-instances --image-id $IMAGE --instance-type "t2.micro" --key-name $KEY --security-group-ids $SGID --subnet-id $SUBNET --user-data file://userdatadb_out.sh --query "Instances[0].InstanceId" --output text)

while true; do
    status=$(aws ec2 describe-instances --instance-id $InstanceId1 --query "Reservations[0].Instances[0].State.Name" --output text)
    if [[ $status == 'running' ]]; then
        PrivateIP=$(aws ec2 describe-instances --instance-id $InstanceId1 --query "Reservations[].Instances[].PrivateIpAddress" --output text)
        echo "IP Privado do Banco de Dados: $PrivateIP"
        break
    fi
done

sleep 60

sed -e "s/USUARIO/$USER/" ./userdata.sh > ./userdata_out.sh
sed -Ei "s/PRIVADOIP/$PrivateIP/" ./userdata_out.sh 
sed -Ei "s/SENHA/$PASSWORD/" ./userdata_out.sh 

echo "Criando servidor de Aplicação..."

InstanceId2=$(aws ec2 run-instances --image-id $IMAGE --instance-type "t2.micro" --key-name $KEY --security-group-ids $SGID --subnet-id $SUBNET --user-data file://userdata_out.sh --query "Instances[0].InstanceId" --output text)

while true; do
    status=$(aws ec2 describe-instances --instance-id $InstanceId2 --query "Reservations[0].Instances[0].State.Name" --output text)
    if [[ $status == 'running' ]]; then
        PublicIP=$(aws ec2 describe-instances --instance-id $InstanceId2 --query "Reservations[].Instances[].PublicIpAddress" --output text)
        break
    fi
done

echo "IP Público do Servidor de Aplicação: ${PublicIP}"

rm ./userdata_out.sh ./userdatadb_out.sh
