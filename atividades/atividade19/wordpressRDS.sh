#!/bin/bash

KEY=$1
USER=$2
PASSWORD=$3
MYIP=$(curl ifconfig.me)
IMAGE="ami-042e8287309f5df03"
GroupName="SGIDScriptsAtividade19"
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
    SGID=$(aws ec2 create-security-group \
        --group-name $GroupName \
        --description "$GroupName description" \
        --vpc-id $VPCID \
        --output text)
    
    aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 22 --cidr $MYIP/32
    aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 80 --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-name $GroupName --protocol tcp --port 3306 --source-group $SGID
else
    SGID=$(aws ec2 describe-security-groups --group-name $GroupName --query "SecurityGroups[0].GroupId" --output text)
fi

DBSubnetGroupName=$(aws rds describe-db-subnet-groups --query "DBSubnetGroups[0].DBSubnetGroupName" --output text)
    
echo "Criando instância de Banco de Dados no RDS..."

DBIdentifier="scriptsdb"

justToNotPrint=$(aws rds create-db-instance \
    --db-instance-identifier $DBIdentifier \
    --db-instance-class db.t2.micro \
    --engine mysql \
    --master-username admin \
    --master-user-password 123scripts456 \
    --vpc-security-group-ids $SGID \
    --no-publicly-accessible \
    --allocated-storage 20 \
    --db-subnet-group-name $DBSubnetGroupName)

while true; do
    DBStatus=$(aws rds describe-db-instances \
        --db-instance-identifier $DBIdentifier \
        --query "DBInstances[0].DBInstanceStatus" \
        --output text)
    if [[ $DBStatus == 'available' ]]; then
        Address=$(aws rds describe-db-instances \
        --db-instance-identifier $DBIdentifier \
        --query "DBInstances[0].Endpoint.Address" \
        --output text)
        echo "Endpoint do RDS: $Address"
        break
    fi
done

sed -e "s/USUARIO/$USER/" ./userdata.sh > ./userdata_out.sh
sed -Ei "s/PRIVADOIP/$Address/" ./userdata_out.sh 
sed -Ei "s/SENHA/$PASSWORD/" ./userdata_out.sh 

echo "Criando servidor de Aplicação..."

InstanceId=$(aws ec2 run-instances \
    --image-id $IMAGE \
    --instance-type "t2.micro" \
    --key-name $KEY \
    --security-group-ids $SGID \
    --subnet-id $SUBNET \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name, Value=WordPress}]' \
    --user-data file://userdata_out.sh \
    --query "Instances[0].InstanceId" \
    --output text)

while true; do
    status=$(aws ec2 describe-instances \
        --instance-id $InstanceId \
        --query "Reservations[0].Instances[0].State.Name" \
        --output text)
    if [[ $status == 'running' ]]; then
        PublicIP=$(aws ec2 describe-instances \
            --instance-id $InstanceId \
            --query "Reservations[].Instances[].PublicIpAddress" \
            --output text)
        break
    fi
done

echo "IP Público do Servidor de Aplicação: ${PublicIP}"

echo "Acesse http://${PublicIP}/wordpress para finalizar a configuração."

rm ./userdata_out.sh
