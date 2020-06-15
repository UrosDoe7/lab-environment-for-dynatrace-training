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
LOCATION4='westeurope'
#LOCATION5='eastus' #Reserved for the kubernetes lab
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

echo $NBENV" Linux VM will be created for your training environement." 
echo "Do you want a Windows VM associated to each of these VM Linux  ? (Y/N) - default : Y"
read InstallWindows
	
if [[ -z $InstallWindows ]]
then
        InstallWindows="Y"
fi
if [[ $InstallWindows = [Yy] ]]
then
    echo "Install 1 linux & 1 windows per environment - Press any key to continue "
    read ResponseLinux
 else
   echo "Install 1 linux per environment (without windows)- Press any key to continue "
   read ResponseLinux
fi

echo "Start by default to \"00\" (Y/N) - default : Y "
read ResponseStart
		
if [[ -z $ResponseStart ]]
then
	ResponseStart="Y"
fi

if [[ $ResponseStart = [Nn] ]]
then
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
fi


##Create the delete_resourcegroup file and add comment and executable privilege 
echo "##Training : "$DOMAIN_NAME > delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
if [[ $InstallWindows = [Yy] ]]
then
	echo 'User;Env Linux;Env Windows;Password (linux and windows)'
	echo '#User;Env Linux;Env Windows;Password (linux and windows)' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
else
	echo 'User;Env Linux;Password'
	echo '#User;Env Linux;Password' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
fi

chmod +x delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh

###
##Write information abouth configuration for validation before creating the VM
for ((i=0+$n; i<$NBENV+$n; ++i));
do
	if (( $i < 5 ))
	then
		X='0' #from 00 to 04
		LOCATION=$LOCATION1
		if [[ $InstallWindows = [Yy] ]]
		then
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		else
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		fi
	fi
	if (( $i >= 5 ))&&(($i < 10))
	then
		X='0' #from 05 to 09
		LOCATION=$LOCATION2
		if [[ $InstallWindows = [Yy] ]]
		then
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		else
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		fi
	fi
	if (( $i >= 10 ))&&(($i < 15))
	then
		X='' #from 10 to 14
		LOCATION=$LOCATION3
		if [[ $InstallWindows = [Yy] ]]
		then
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		else
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		fi
	fi
	if (( $i >= 15 ))&&(($i < 20))
	then
		X='' #from 10 to 20
		LOCATION=$LOCATION4
		if [[ $InstallWindows = [Yy] ]]
		then
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;win'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		else
			echo 'user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD''
			echo '#user'$X$i';'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com;'$PASSWORD'' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
		fi
	fi
done
	
echo ""
echo "Install easytravel docker (Y/N) - default : Y"
read EasyTravel
if [[ -z $EasyTravel ]]
then
	EasyTravel="Y"
fi

echo ""
echo "################################################################################################################################"
echo "#### Once the VMs created, you have to start them from your Azure subscription :	 				    ####"
echo "####	https://portal.azure.com/#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Compute%2FVirtualMachines  ####"
echo "####															    ####"
echo "#### At the end of the training, delete all the Azure resource groups :							    ####"
echo "####	a script has been generated localy on your cli bash environement -> ./delete_ressourcegroup_"$TIME".sh       ####"    															  ####"
echo "################################################################################################################################"
echo ""


###create VM
echo 'START installation='`date +%Y%m%d%H%M%S`
for ((i=0+$n; i<$NBENV+$n; ++i));
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
			
	###Create VM Linux
	echo 'create vm : '$DOMAIN'.'$LOCATION'.cloudapp.azure.com'
	az deployment group create \
		--resource-group $RESOURCE_GROUP \
		--template-uri https://raw.githubusercontent.com/JLLormeau/lab-environment-for-dynatrace-training/master/azuredeploy-linux.json \
		--parameters  adminUsername="$user" adminPasswordOrKey="$PASSWORD" authenticationType="password" dnsNameForPublicIP="$DOMAIN" vmSize="$SIZE_LINUX";			

	###install shellinabox to go to the linux env from a browser (port 443)
	az vm run-command invoke -g "$RESOURCE_GROUP" -n "$DOMAIN" --command-id RunShellScript --scripts "apt-get install shellinabox && sed -i 's/4200/443/g' /etc/default/shellinabox";
	###Install EasyTravel
	if [[ $EasyTravel = [Yy] ]]
	then
		az vm run-command invoke -g "$RESOURCE_GROUP" -n "$DOMAIN" --command-id RunShellScript --scripts "cd /home && git clone https://github.com/JLLormeau/dynatracelab_easytraveld.git && cd dynatracelab_easytraveld && chmod +x start-stop-easytravel.sh && cp start-stop-easytravel.sh /etc/init.d/start-stop-easytravel.sh && update-rc.d start-stop-easytravel.sh defaults";
	fi
	###stop VM Linux
	az vm deallocate -g "$RESOURCE_GROUP" -n "$DOMAIN";
	###VM Linux is created and stopped - start the VM Linux from the azure portal
	###Create VM Windows
	if [[ $InstallWindows = [Yy] ]]
	then
		echo 'create vm : win'$DOMAIN'.'$LOCATION'.cloudapp.azure.com'
		az deployment group create \
			--resource-group $RESOURCE_GROUP \
			--template-uri https://raw.githubusercontent.com/JLLormeau/lab-environment-for-dynatrace-training/master/azuredeploy-windows.json \
			--parameters  adminUsername="$user" virtualMachines_MyWinVM_name=MyWinVM"$X""$i" adminPasswordOrKey="$PASSWORD" dnsNameForPublicIP=win"$DOMAIN" vmSize="$SIZE_WINDOWS";		
		###add linux to the NSG Windows (for TCP POrt 22, 443, 80, 27017 mongodb) only with windows VM
		az network nic update -g "$RESOURCE_GROUP" -n myVMNicD --network-security-group MyWinVM-nsg;
		###Change the RDP default port to 443 (not in the script for the moment)
		#az vm run-command invoke  --command-id SetRDPPort --name MyWinVM"$X""$i" -g $RESOURCE_GROUP --parameters "RDPPORT=443"; 
		###Stop VM Windows
		az vm deallocate -g "$RESOURCE_GROUP" -n MyWinVM"$X""$i";
		###VM Windows is created and stopped - start the VM windows from the azure portal
	fi			

	###write the az cli in the delete script for deleting all thiese resource group at the end of the training
	echo "echo "$RESOURCE_GROUP >> delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
	echo "az group delete --name "$RESOURCE_GROUP" --y" >> delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
done

echo 'END installation='`date +%Y%m%d%H%M%S`
} | tee $log
