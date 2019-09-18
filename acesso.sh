#!/bin/bash
echo "Qual Profile vai utilizar ?"
read profile
export AWS_PROFILE=$profile

echo "Qual a Região da Instancia ?"
read region

echo "Gerando lista de instancias gerenciaveis, aguarde... "
#aws ssm describe-instance-information --region $region | grep InstanceId > instancias.txt 
aws ssm describe-instance-information --region $region | \
grep InstanceId | \
cut -d\" -f4 | \
while read instanceid ; do \ 
aws ec2 describe-instances --instance-ids $instanceid \
--query "Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key=='Name']|[0].Value}" \
--output=text ; done > instancias.txt 2> /dev/null

aws ssm describe-instance-information --region $region | grep InstanceId > instancias.txt 


if [[ $(wc -l instancias.txt | cut -d\  -f1 2> /dev/null) -gt 0 ]] 
then
  echo "Ids encontrados no profile $profile"
	cat -n instancias.txt
	read -p "Escolha o ID: " id 
	selecionado=`sed "$id !d" instancias.txt | awk '{print $1}' | sed 's/"//g;s/,//g'`
	echo "O ID escolhido é: " $selecionado
	
	aws ssm start-session --target $selecionado --region $region


else
	
	echo Nenhuma instancia encontrada na regiao $region
	
fi
