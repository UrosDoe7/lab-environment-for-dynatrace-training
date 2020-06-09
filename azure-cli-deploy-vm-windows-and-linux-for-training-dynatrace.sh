#!/bin/bash
#set variables
#NBENV = nb de VM
#DOMAIN_NAME = must be unique only [a-z] lower case
TIME=`date +%Y%m%d%H%M%S`
DOMAIN_NAME_DEFAULT='dynatracelab'$TIME
PASSWORD='Dynatrace@2020'
SIZE_LINUX='Standard_D1_v2' #1 CPU 3.5 GB
SIZE_WINDOWS='Standard_B2s'   #2 CPU 4 GB
#LOCATION='westeurope'
#LOCATION='northeurope'
#LOCATION='uksouth'
#LOCATION='francecentral'
#LOCATION='ukwest'
#X='0' #from 00 to 09
#X='1' #from 10 to 19
NBENV=0

echo "Create several Ubuntu VM with Docker Engine on Azure - from JLL version 1.0"
#while [ -z $NBENV ]||[ $NBENV > 12 ]
while  (($NBENV > 18))||(( $NBENV < 1))
do
        echo "How many VM ? 1, 2 ... 18 max ? "
        read NBENV
done
echo "What is the name of the project ? must be unique and only [a-z0-9] lower case (no - or _), default : $DOMAIN_NAME_DEFAULT "
read DOMAIN_NAME
if [[ -z $DOMAIN_NAME ]]
then
        DOMAIN_NAME=$DOMAIN_NAME_DEFAULT
fi
echo "##Training : "$DOMAIN_NAME > delete_ressourcegroup_$DOMAIN_NAME.sh
for ((i=0; i<$NBENV; ++i));
do
        if (( $i < 6 ))
        then
                X='0' #from 00 to 09
				LOCATION='westeurope'
                echo 'Windows=win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD''
				echo '#Windows=win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD'' >  delete_ressourcegroup_$DOMAIN_NAME.sh
 
        fi
        if (( $i >= 6 ))&&(($i < 10))
        then
                X='0' #from 00 to 09
				LOCATION='northeurope'
                echo 'Windows=win'$DOMoAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD''
				echo '#Windows=win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD'' >  delete_ressourcegroup_$DOMAIN_NAME.sh
        fi
        if (( $i >= 10 ))&&(($i < 12))
        then
				X='' #from 10 to 19
                LOCATION='northeurope'
                echo 'Windows=win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD''
				echo '#Windows=win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD'' >  delete_ressourcegroup_$DOMAIN_NAME.sh

        fi
		        if (( $i >= 12 ))&&(($i < 18))
        then
				X='' #from 10 to 17
                LOCATION='francecentral'
                echo 'Windows=win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD''
				echo '#Windows=win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; Linux='$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com; usr=user'$X$i'; pwd='$PASSWORD'' >  delete_ressourcegroup_$DOMAIN_NAME.sh

        fi

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
	for ((i=0; i<$NBENV; ++i));
	do
        if (( $i < 6 ))
        then
                X='0' #from 00 to 09
				LOCATION='westeurope'
        fi
        if (( $i >= 6 ))&&(($i < 10))
        then
                X='0' #from 00 to 09
				LOCATION='northeurope'
        fi
        if (( $i >= 10 ))&&(($i < 12))
        then
                X='' #from 10 to 19
				LOCATION='northeurope'
        fi
		        if (( $i >= 12 ))&&(($i < 18))
        then
				X='' #from 10 to 17
                LOCATION='francecentral'
        fi

		user='user'$X$i
		RESOURCE_GROUP=$DOMAIN_NAME$X$i
		DOMAIN=$DOMAIN_NAME$X$i
		echo 'create resource group : '  $RESOURCE_GROUP
		az group create \
			--name $RESOURCE_GROUP \
			--location $LOCATION \
			--tags $DOMAIN
		echo 'create vm : win'$DOMAIN'.'$LOCATION'.cloudapp.azure.com'
		az deployment group create \
			--resource-group $RESOURCE_GROUP \
			--template-uri https://raw.githubusercontent.com/JLLormeau/lab-environment-for-dynatrace-training/master/azuredeploy-windows.json \
			--parameters  adminUsername="$user" adminPasswordOrKey="$PASSWORD" dnsNameForPublicIP=win"$DOMAIN" vmSize="$SIZE_WINDOWS";		
		az vm run-command invoke  --command-id SetRDPPort --name MyWinVM -g $RESOURCE_GROUP --parameters "RDPPORT=443"; 
		#echo 'user = '$user' & password = '$PASSWORD
		echo 'create vm : '$DOMAIN'.'$LOCATION'.cloudapp.azure.com'
		az deployment group create \
			--resource-group $RESOURCE_GROUP \
			--template-uri https://raw.githubusercontent.com/JLLormeau/lab-environment-for-dynatrace-training/master/azuredeploy.json \
			--parameters  adminUsername="$user" adminPasswordOrKey="$PASSWORD" authenticationType="password" dnsNameForPublicIP="$DOMAIN" vmSize="$SIZE_LINUX";
			
		az network nic update -g "$RESOURCE_GROUP" -n myVMNicD --network-security-group MyWinVM-nsg;
		echo "az group delete --name "$RESOURCE_GROUP" --y" >> delete_ressourcegroup_$DOMAIN_NAME.sh
	done
	chmod +x delete_ressourcegroup_$DOMAIN_NAME.sh
fi
