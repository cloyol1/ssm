#!/bin/bash
echo "Qual Profile vai utilizar ?"
read profile
export AWS_PROFILE=$profile

echo "Qual a Região da Instancia ?"
read region

echo "Gerando lista de instancias gerenciaveis, aguarde... "
aws ssm describe-instance-information --region $region | grep InstanceId > instancias-ssm.txt
aws ec2 describe-instances --instance-ids --region $region --query "Reservations[*].Instances[*].{Instance:InstanceId,Name:Tags[?Key=='Name']|[0].Value}" --output=text > instancias-nomes.txt 2> /dev/null
rm -f instancias-gerenciaveis.txt
cat instancias-nomes.txt | while read instancia nome ; do grep $instancia instancias-ssm.txt > log_grep.txt 2>&1 && echo -e "${instancia} ${nome}" >> instancias-gerenciaveis.txt ; done
if [[ $(wc -l instancias-gerenciaveis.txt | cut -d\  -f1 2> /dev/null) -gt 0 ]] 
then
  echo "Ids encontrados no profile $profile"
	cat -n instancias-gerenciaveis.txt
	read -p "Escolha o ID: " id 
	selecionado=`sed "$id !d" instancias-gerenciaveis.txt | awk '{print $1}' # | sed 's/"//g;s/,//g'`
	echo "O ID escolhido é: " $selecionado
	aws ssm start-session --target $selecionado --region $region
else
	echo Nenhuma instancia encontrada na regiao $region
fi

