#!/bin/bash

KEY=$1
IMAGE="ami-042e8287309f5df03"
GroupName="SGIDScripts"
SUBNET=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
VPCID=$(aws ec2 describe-subnets --query "Subnets[0].VpcId" --output text)
SGID=$(aws ec2 create-security-group --group-name $GroupName --description "SGIDScripts description" --vpc-id $VPCID --output text)

aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 80 --cidr 0.0.0.0/0

echo "Criando instancia..."

InstanceId=$(aws ec2 run-instances --image-id $IMAGE --instance-type "t2.micro" --key-name $KEY --security-group-ids $SGID --subnet-id $SUBNET --user-data file://aux.sh --query "Instances[0].InstanceId" --output text)

IP=$(aws ec2 describe-instances --instance-id $InstanceId --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
echo "Acesse: http://$IP/" 