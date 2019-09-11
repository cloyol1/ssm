#!/bin/bash
echo "Qual Profile vai utilizar?"
read profile
export AWS_PROFILE=$profile

echo "Qual a Região da Instancia"
read region

aws ssm describe-instance-information --region $region | grep InstanceId > instancias.txt 

if [[ $(wc -l instancias.txt | cut -d\  -f1 2> /dev/null) -gt 0 ]] 
then
	
  echo "Ids encontrados no profile $profile"
	cat instancias.txt
	
	echo "Escolha o Id para acesso"
	read id
	
	aws ssm start-session --target $id --region $region
	
else
	
	echo Nenhuma instancia encontrada na regiao $region
	
fi
