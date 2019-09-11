#!/bin/bash
echo "Qual Profile vai utilizar?"
read profile
export AWS_PROFILE=$profile

echo "Ids encontrados no profile $profile"

aws ssm describe-instance-information | grep InstanceId > instancias.txt 

cat instancias.txt

echo "Escolha o Id para acesso"
read id

echo "Qual a Região da Instancia"
read region

aws ssm start-session --target $id --region $region
