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
	cat -n instancias.txt | awk '{print $1, $3}' | sed 's/"//g' | sed 's/,//g'
	read -p "Escolha um ID: " id 
	selecionado=`sed "$id !d" instancias.txt | sed 's/"//g;s/,//g'`
	echo "O ID escolhido é: " $selecionado
	
	aws ssm start-session --target $selecionado --region $region
	
else
	
	echo Nenhuma instancia encontrada na regiao $region
	
fi
