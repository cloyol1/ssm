#!/bin/bash
echo "Qual Profile vai utilizar?"
read profile
export AWS_PROFILE=$profile

echo "Qual o ID da Instancia"
read id

echo "Qual a Região da Instancia"
read region

aws ssm start-session --target $id --region $region
