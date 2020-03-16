#!/bin/bash
#set variables 
#NBVM = nb de VM
#DOMAIN_NAME = must be unique only [a-z] lower case
TIME=`date +%Y%m%d%H%M%S`
DOMAIN_NAME_DEFAULT='dynatracelab'$TIME
PASSWORD='Dynatrace@2020'
LOCATION='westeurope'
SIZE='Standard_B2s'

echo "Create several Ubuntu VM with Docker Engine on Azure - from JLL version 1.0"
echo "How many VM ? 1, 2 ... 8 ? - default : 1"
read NBVM
if [[ -z $NBVM ]]
then
	NBVM=1
fi
echo "What is the name of the project ? must be unique and only [a-z0-9] lower case (no - or _), default : $DOMAIN_NAME_DEFAULT " 
read DOMAIN_NAME
if [[ -z $DOMAIN_NAME ]]
then
	DOMAIN_NAME=$DOMAIN_NAME_DEFAULT
fi
for ((i=0; i<$NBVM; ++i));
do
	echo 'hostname : '$DOMAIN_NAME'0'$i'.'$LOCATION'.cloudapp.azure.com with usr = USER0'$i' & Pwd = '$PASSWORD' & Size = '$SIZE''
done
echo ""
echo "Continue (Y/N) - default : Y"
read Response
if [[ -z $Response ]]
then
	Response="Y"
fi
if [ $Response = "Y" ] || [ $Response = "y" ]
then
	#create VM
	for ((i=0; i<$NBVM; ++i));
	do
		USER='USER0'$i
		RESOURCE_GROUP=$DOMAIN_NAME'0'$i
		DOMAIN=$DOMAIN_NAME'0'$i
		echo 'create resource group : '  $RESOURCE_GROUP
		az group create \
			--name $RESOURCE_GROUP \
			--location $LOCATION \
			--tags $DOMAIN
		echo 'create vm : ' $DOMAIN'.'$LOCATION'.cloudapp.azure.com'
		az deployment group create \
			--resource-group $RESOURCE_GROUP \
			--template-uri https://raw.githubusercontent.com/JLLormeau/azure-cli-deploy-vm-for-workshop/master/azuredeploy.json \
			--parameters  adminUsername="$USER" adminPasswordOrKey="$PASSWORD" authenticationType="password" dnsNameForPublicIP="$DOMAIN" vmSize="$SIZE";
	done
fi
