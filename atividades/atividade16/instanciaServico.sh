#!/bin/bash
# Correção: 1,0
KEY=$1
IMAGE="ami-042e8287309f5df03"
GroupName="SGIDScriptsAtividade16"
SUBNET=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
VPCID=$(aws ec2 describe-subnets --query "Subnets[0].VpcId" --output text)
SGID=$(aws ec2 create-security-group --group-name $GroupName --description "$GroupName description" --vpc-id $VPCID --output text)

aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 80 --cidr 0.0.0.0/0

echo "Criando servidor de Monitoramento em CRON..."

InstanceId=$(aws ec2 run-instances --image-id $IMAGE --instance-type "t2.micro" --key-name $KEY --security-group-ids $SGID --subnet-id $SUBNET --user-data file://userdata.sh --query "Instances[0].InstanceId" --output text)

while true; do
    status=$(aws ec2 describe-instances --instance-id $InstanceId --query "Reservations[0].Instances[0].State.Name" --output text)
    if [[ $status == 'running' ]]; then
        echo "Instância em estado \"running\""
        break
    fi
done


IP=$(aws ec2 describe-instances --instance-id $InstanceId --query "Reservations[0].Instances[0].PublicIpAddress" --output text)

echo "Acesse: http://${IP}/"
