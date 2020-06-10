#!/bin/bash
#set variables
#NBENV = nb de VM
#DOMAIN_NAME = must be unique only [a-z] lower case
TIME=`date +%Y%m%d%H%M%S`
DOMAIN_NAME_DEFAULT='dynatracelab'$TIME
PASSWORD='Dynatrace@2020'
SIZE_LINUX='Standard_D1_v2' #1 CPU 3.5 GB
SIZE_WINDOWS='Standard_B2s'   #2 CPU 4 GB
LOCATION1='uksouth'
LOCATION2='northeurope'
LOCATION3='francecentral'
LOCATION4='ukwest'
#LOCATION5='westeurope' #Reserved for the kubernetes lab
#LOCATION6='eastus2' #Reserved for the kubernetes lab
log=deploy-vm-windows-and-linux-for-training-dynatrace-$TIME.log
NBENV=0
n=0
{
echo "Create several Env with VM Windows and Vm Linux on Azure - from JLL version 2.0" 
echo ""
echo "PREREQUISITE : "
echo "Each environnement contains 2 Public IP and : "
echo "  - 1 Linux Ubuntu with Doker 	- Size Linux :	"$SIZE_LINUX
echo "  - 1 Windows 10 with Open-SSH 	- Size Windows:	"$SIZE_WINDOWS
echo ""
echo "For 5 env, you need all the quota of "$LOCATION1 
echo "For 10 env, you need all the quota of "$LOCATION1" and "$LOCATION2
echo "For 15 env, you need all the quota of "$LOCATION1", "$LOCATION2" and "$LOCATION3
echo "For 20 env, you need all the quota of "$LOCATION1", "$LOCATION2", "$LOCATION3" and "$LOCATION4
echo ""
echo $LOCATION1"                         used            total"    
az vm list-usage --location $LOCATION1 -o table | grep "Total Regional vCPUs";
echo $LOCATION2    
az vm list-usage --location $LOCATION2 -o table | grep "Total Regional vCPUs";
echo $LOCATION3    
az vm list-usage --location $LOCATION3 -o table | grep "Total Regional vCPUs";
echo $LOCATION4    
az vm list-usage --location $LOCATION4 -o table | grep "Total Regional vCPUs";
echo ""
echo "Check that you have enough quota for these environments in https://portal.azure.com - your subscription - Usage + quotas"
echo "Edit the script to change the region"
echo "Ctrl/c to quit"
echo ""

while  (($NBENV > 20))||(( $NBENV < 1))
do
        echo "How many VM ? 1, 2 ... 20 max ? "
        read NBENV
done
if [[ -z $DOMAIN_NAME ]]
then
        DOMAIN_NAME=$DOMAIN_NAME_DEFAULT
fi
echo "What is the name of the project ? must be unique and only [a-z0-9] lower case (no - or _), default : $DOMAIN_NAME_DEFAULT "
read DOMAIN_NAME
if [[ -z $DOMAIN_NAME ]]
then
        DOMAIN_NAME=$DOMAIN_NAME_DEFAULT
		Projetc="N"
fi
while [[ -z $Projetc ]]||[[ $Projetc != [XxNn] ]]
do 
	echo "Is it an existing project? X=eXisting project, N=new project - (X/N)"
	read Projetc
done
if [[ $Projetc = [xX] ]]
then
	echo "##Training : "$DOMAIN_NAME >> delete_ressourcegroup_$DOMAIN_NAME.sh
	if (($NBENV < 20))
	then
		reste=$((20-$NBENV))
		echo "Choose \"n\" between 0 and "$reste" the digit to start the env: "
		read n
		while  (($n > $reste))||(( n < 1))
		do
			echo "Choose n between 0 and "$NBENV" the digit to start the env "
			read n
		done
	fi
else
	echo "##Training : "$DOMAIN_NAME > delete_ressourcegroup_$DOMAIN_NAME.sh
	n=0
fi

echo 'User;Env Linux;Env Windows;password (linux and windows)'
echo '#User;Env Linux;Env Windows;password (linux and windows)' >>  delete_ressourcegroup_$DOMAIN_NAME.sh
chmod +x delete_ressourcegroup_$DOMAIN_NAME.sh

for ((i=0+$n; i<$NBENV+$n; ++i));
do
        if (( $i < 5 ))
        then
            X='0' #from 00 to 04
			LOCATION=$LOCATION1
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME.sh
	 
        fi
        if (( $i >= 5 ))&&(($i < 10))
        then
			X='0' #from 05 to 09
			LOCATION=$LOCATION2
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME.sh
			fi
        if (( $i >= 10 ))&&(($i < 14))
        then
			X='' #from 10 to 14
            		LOCATION=$LOCATION3
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME.sh
        fi
		if (( $i >= 14 ))&&(($i < 20))
        then
			X='' #from 10 to 20
            		LOCATION=$LOCATION4
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME.sh
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
	echo 'START='`date +%Y%m%d%H%M%S`
	for ((i=0; i<$NBENV; ++i));
	do
        if (( $i < 5 ))
        then
                X='0' #from 00 to 04
				LOCATION=$LOCATION1
        fi
        if (( $i >= 5 ))&&(($i < 10))
        then
                X='0' #from 05 to 09
				LOCATION=$LOCATION2
        fi
        if (( $i >= 10 ))&&(($i < 15))
        then
                X='' #from 10 to 14
				LOCATION=$LOCATION3
        fi
		        if (( $i >= 15 ))&&(($i < 20))
        then
				X='' #from 15 to 20
                LOCATION=$LOCATION4
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
			--parameters  adminUsername="$user" virtualMachines_MyWinVM_name=MyWinVM"$X""$i" adminPasswordOrKey="$PASSWORD" dnsNameForPublicIP=win"$DOMAIN" vmSize="$SIZE_WINDOWS";		
		#az vm run-command invoke  --command-id SetRDPPort --name MyWinVM -g $RESOURCE_GROUP --parameters "RDPPORT=443"; 
		az vm deallocate -g "$RESOURCE_GROUP" -n MyWinVM;
		#echo 'user = '$user' & password = '$PASSWORD
		echo 'create vm : '$DOMAIN'.'$LOCATION'.cloudapp.azure.com'
		az deployment group create \
			--resource-group $RESOURCE_GROUP \
			--template-uri https://raw.githubusercontent.com/JLLormeau/lab-environment-for-dynatrace-training/master/azuredeploy-linux.json \
			--parameters  adminUsername="$user" adminPasswordOrKey="$PASSWORD" authenticationType="password" dnsNameForPublicIP="$DOMAIN" vmSize="$SIZE_LINUX";			
		az network nic update -g "$RESOURCE_GROUP" -n myVMNicD --network-security-group MyWinVM-nsg;
		az vm run-command invoke -g $RESOURCE_GROUP" -n $RESOURCE_GROUP" --command-id RunShellScript --scripts "sudo apt-get install shellinabox && sudo sed -i 's/4200/443/g' /etc/default/shellinabox && sudo systemctl daemon-reload	&& sudo service shellinabox restart "
		az vm deallocate -g "$RESOURCE_GROUP" -n "$DOMAIN"
		echo "echo "$RESOURCE_GROUP >> delete_ressourcegroup_$DOMAIN_NAME.sh
		echo "az group delete --name "$RESOURCE_GROUP" --y" >> delete_ressourcegroup_$DOMAIN_NAME.sh
	done
	echo 'END='`date +%Y%m%d%H%M%S`
fi
} | tee $log
