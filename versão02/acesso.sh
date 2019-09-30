#!/bin/bash
####Dependência pip3 install aws-ssm-tools####

##### setar o profile e exporta para variavel de Ambiente #####
echo "Qual Profile vai utilizar ?"
read profile
export AWS_PROFILE=$profile

##### setar região onde estão as instancias #####
echo "Qual a Região da Instancia ?"
read region

echo "Gerando lista de instancias gerenciaveis, aguarde... "

ssm-session --list | awk '{print $1 " " $3}'  > teste.txt

if [[ $(wc -l teste.txt | cut -d\  -f1 2> /dev/null) -gt 0 ]]
then
  echo "Ids encontrados no profile $profile"
        cat -n teste.txt
        read -p "Escolha o ID: " id
        selecionado=`sed "$id !d" teste.txt | awk '{print $1}' # | sed 's/"//g;s/,//g'`
        echo "O ID escolhido é: " $selecionado

        aws ssm start-session --target $selecionado --region $region

else

        echo Nenhuma instancia encontrada na regiao $region

fi
