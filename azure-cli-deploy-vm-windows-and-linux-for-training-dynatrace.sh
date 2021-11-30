#!/bin/bash
#design by JLLormeau Dynatrace

TIME=`date +%Y%m%d%H%M%S`
DOMAIN_NAME_DEFAULT='dynatracelab'$TIME
PASSWORD='Dynatrace@2021'
#SIZE_LINUX='Standard_D1_v2' #1 CPU 3.5 GB
SIZE_LINUX='Standard_B2s' #2 CPU 4 GB
SIZE_WINDOWS='Standard_B2s'   #2 CPU 4 GB
LOCATION1='francecentral'
LOCATION2='westeurope'
LOCATION3='northeurope'
LOCATION4='uksouth'
#LOCATION5='eastus' #Reserved for the kubernetes lab
#LOCATION6='eastus2' #Reserved for the kubernetes lab
APPLY="N"
START_ENV=0
NBENV=2
END_ENV=$(($END_ENV-$START_ENV))
WINDOWS_ENV="N"
EASYTRAVEL_ENV="Y"
MONGO_STOP="Y"
KUBE_SCRIPT="N"
VM_STARTED="N"
HOUR_MONGO_STOP="11"
log=deploy-vm-windows-and-linux-for-training-dynatrace-$TIME.log
n=0
{
clear
echo "PREREQUISITE : "
echo "Each training environment can contain 2 Public IP with : "
echo "  - 1 Linux Ubuntu with Docker     - Size Linux :  "$SIZE_LINUX
echo "  - (optional) 1 Windows 10         - Size Windows: "$SIZE_WINDOWS
echo ""
echo "For 5 env, you need all the quota of "$LOCATION1
echo "For 10 env, you need all the quota of "$LOCATION1" and "$LOCATION2
echo "For 15 env, you need all the quota of "$LOCATION1", "$LOCATION2" and "$LOCATION3
echo "For 20 env, you need all the quota of "$LOCATION1", "$LOCATION2", "$LOCATION3" and "$LOCATION4
echo ""
echo $LOCATION1"                      used            total"
az vm list-usage --location $LOCATION1 -o table | grep "Total Regional vCPUs";
echo $LOCATION2
az vm list-usage --location $LOCATION2 -o table | grep "Total Regional vCPUs";
echo $LOCATION3
az vm list-usage --location $LOCATION3 -o table | grep "Total Regional vCPUs";
echo $LOCATION4
az vm list-usage --location $LOCATION4 -o table | grep "Total Regional vCPUs";
echo ""
sleep 0.1
read  -p "Press any key to continue " pressanycase

while [ "$APPLY" !=  "Y" ]
do
        clear
        echo "CONFIGURATION : "
        echo ""
        echo "Total Env (max 20) ="$NBENV
        if [ $(($START_ENV+$NBENV)) -lt 10 ]; then END_ENV2="0""$(($START_ENV+$NBENV-1))"; else END_ENV2="$(($START_ENV+$NBENV-1))";fi
        if [ $(($START_ENV)) -lt 10 ]; then START_ENV2="0"$START_ENV;else START_ENV2=$START_ENV;fi
        echo "  * Fisrt VM linux name (min 00)          ="$DOMAIN_NAME_DEFAULT$START_ENV2
        echo "  * Last VM linux name (max 19)           ="$DOMAIN_NAME_DEFAULT$END_ENV2
        echo ""
        echo "0) config env : training name                          ="$DOMAIN_NAME_DEFAULT
        echo "1) config env : password                               ="$PASSWORD
        echo "2) config env : value fisrt env                        ="$START_ENV2
        echo "3) config env : nbr total env                          ="$NBENV
        echo "4) add env : windows VM to env                         ="$WINDOWS_ENV
        echo "5) add env : easytravel installed                      ="$EASYTRAVEL_ENV
        if [[ $EASYTRAVEL_ENV = [Y] ]]; then echo "6) add env : cron to stop Mongo at "$HOUR_MONGO_STOP" H GMT            ="$MONGO_STOP;fi
        if [[ $MONGO_STOP = [Y] && $EASYTRAVEL_ENV = [Y] ]]; then echo "7) stop Mongo : hour (GMT) of Mongo shutdown           ="$HOUR_MONGO_STOP; fi
        echo "8) kubernetes : script to deploy Azure Vote App on AKS ="$KUBE_SCRIPT
        echo "9) start env : VM started after installation           ="$VM_STARTED
        echo "A) apply and deploy the VM - (Ctrl/c to quit)"
        echo ""
        sleep 0.1
        read  -p "Input Selection (0, 1, 2, ..., 8, 9  or A): " reponse

        case "$reponse" in
                "0") verif="ko"
                      until [ $verif = "ok" ]; do read  -p "0) config env : training name with rule [a-z][a-z][a-z][a-z][a-z][a-z0-9]+$   " DOMAIN_NAME_DEFAULT
                       if [[ $DOMAIN_NAME_DEFAULT =~ ^[a-z][a-z][a-z][a-z][a-z][a-z0-9]+$ ]] &&  [[ `echo $DOMAIN_NAME_DEFAULT|cut -c -5` != "azure"  ]];then
                        verif="ok"
                        else verif="ko";if  [[ `echo $DOMAIN_NAME_DEFAULT|cut -c -5` = "azure"  ]]; then echo "the VM name can't start with \"azure\" pattern" ; value="ko";read pressanycase;fi
                     fi;done
                ;;
                "1") verif="ko"
                      until [ $verif = "ok" ]; do read  -p "1) conf env : password with 12 characters mini and 1 lower case, 1 upper case, 1 number, and @ or &   " PASSWORD
                      if [[ ${#PASSWORD} -ge 12 && "$PASSWORD" ==  *[[:lower:]]*  && "$PASSWORD" ==  *[[:upper:]]*  && "$PASSWORD" == *[0-9]* && "$PASSWORD" == *[\&\@]* ]];then
                        verif="ok"
                        else verif="ko";fi;done
                ;;
                "2") value=-1
                     until [ $value -ge 0 -a  $value -le $((20-$NBENV)) ]; do read -p "2) config env : start value (between 0 & "$((20-$NBENV))")   " value;  done
                   START_ENV=$value
                ;;
                "3") value=-1
                     until [ $value -gt 0 -a  $value -le $((20-$START_ENV)) ];do read -p "3) config env : nbr total env (maxi "$((20-$START_ENV))")   " value;  done
                   NBENV=$value
                ;;
                "4") if [ "$WINDOWS_ENV" = "Y" ]; then WINDOWS_ENV="N"; echo "4) add env : window VM to env   =N" ; else WINDOWS_ENV="Y"; echo "4) add env : window VM to env   =Y"; fi
					sleep 0.1;read  -p "Press any key to continue " pressanycase
				;;
                "5") if [ "$EASYTRAVEL_ENV" = "Y" ]; then EASYTRAVEL_ENV="N"; echo "5) add env : easytravel installed   =N"; else EASYTRAVEL_ENV="Y";echo "5) add env : easytravel installed   =Y"; fi
					sleep 0.1;read  -p "Press any key to continue " pressanycase
				;;
                "6") if [ "$MONGO_STOP" = "Y" ]; then MONGO_STOP="N";echo "6) add env : cron to stop Mongo at "$HOUR_MONGO_STOP" H GMT   =N"; else MONGO_STOP="Y";echo "6) add env : cron to stop Mongo at "$HOUR_MONGO_STOP" H GMT   =Y"; fi
					sleep 0.1;read  -p "Press any key to continue " pressanycase
				;;
                "7") value=-1; until [ $value -ge 0 -a  $value -lt 24 ]; do read  -p "7) stop Mongo : hour (GMT) of Mongo shutdown (restart auto 20 minutes after)   =" value; done
					HOUR_MONGO_STOP=$value
                ;;
                "8") if [ "$KUBE_SCRIPT" = "Y" ]; then KUBE_SCRIPT="N";echo "8) kubernetes : script to deploy Azure Vote App on AKS   =N"; else KUBE_SCRIPT="Y";echo "8) kubernetes : script to deploy Azure Vote App on AKS   =Y"; fi
					sleep 0.1;read  -p "Press any key to continue " pressanycase
				;;
                "9") if [ "$VM_STARTED" = "Y" ]; then VM_STARTED="N";echo "9) start env : VM started after installation   =N"; else VM_STARTED="Y";echo "9) start env : VM started after installation   =Y"; fi
					sleep 0.1;read  -p "Press any key to continue " pressanycase
				;;
                "A") APPLY="Y"
                                DOMAIN_NAME=$DOMAIN_NAME_DEFAULT
        esac
done
##Create the delete_resourcegroup file and add comment and executable privilege
echo ""
echo ""
echo "##Training : "$DOMAIN_NAME > delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
if [[ $WINDOWS_ENV = [Y] ]]
then
        echo 'ENVIRONMENT : Linux & Windows (same credentials)'
        echo '#User;Env Linux;Env Windows;Password (linux and windows)' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
else
        echo 'ENVIRONMENT : Linux'
        echo '#User;Env Linux;Password' >>  delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
fi

chmod +x delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh

###
##Write information abouth configuration for validation before creating the VM
for ((i=0+$START_ENV; i<$NBENV+$START_ENV; ++i));
do
        if (( $i < 5 ))
        then
                X='0' #from 00 to 04
                LOCATION=$LOCATION1
                if [[ $WINDOWS_ENV = [Y] ]]
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
                if [[ $WINDOWS_ENV = [Y] ]]
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
                if [[ $WINDOWS_ENV = [Y] ]]
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
                if [[ $WINDOWS_ENV = [Y] ]]
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
sleep 0.1
read  -p "Press any key to continue " pressanycase

echo ""
echo "##################################################################################################################################"
echo "#### Once the VMs created, you have to start them from your Azure subscription :                                              ####"
echo "####      https://portal.azure.com/#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Compute%2FVirtualMachines  ####"
echo "####                                                                                                                          ####"
echo "#### At the end of the training, delete all the Azure resource groups :                                                       ####"
echo "####      a script has been generated localy on your cli bash environment -> ./delete_ressourcegroup_"$TIME".sh        ####"
echo "##################################################################################################################################"
echo ""


###create VM
echo 'START installation='`date +%Y%m%d%H%M%S`
for ((i=0+$START_ENV; i<$NBENV+$START_ENV; ++i));
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
        if [[ $EASYTRAVEL_ENV = [Y] ]]
        then
                az vm run-command invoke -g "$RESOURCE_GROUP" -n "$DOMAIN" --command-id RunShellScript --scripts "cd /home && git clone https://github.com/JLLormeau/dynatracelab_easytraveld.git && sudo chmod 777 dynatracelab_easytraveld && cd dynatracelab_easytraveld && sed -i 's/easytravel-www/easytravel"$X$i"-www/g' docker-compose.yml && chmod +x start-stop-easytravel.sh && cp start-stop-easytravel.sh /etc/init.d/start-stop-easytravel.sh && update-rc.d start-stop-easytravel.sh defaults";
                        if [[ $MONGO_STOP = [Y] ]]
                        then
                                az vm run-command invoke -g "$RESOURCE_GROUP" -n "$DOMAIN" --command-id RunShellScript --scripts "service cron start && (crontab -l 2>/dev/null; echo \"0 "$HOUR_MONGO_STOP" * * * date >> /home/cron.log && /home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo >> /home/cron.log 2>&1\") | crontab  - && (crontab -l 2>/dev/null; echo \"20 "$HOUR_MONGO_STOP" * * * date >> /home/cron.log && /home/dynatracelab_easytraveld/start-stop-easytravel.sh restart >> /home/cron.log 2>&1\") | crontab -";
                        fi
        fi
        ###Add script to deploi kubernetes AKS with your Azure Service Principal
        if [[ $KUBE_SCRIPT = [Y] ]]
        then
                az vm run-command invoke -g "$RESOURCE_GROUP" -n "$DOMAIN" --command-id RunShellScript --scripts "cd /home && git clone https://github.com/JLLormeau/dynatracelab_kubernetesaks.git && sudo chmod 777 dynatracelab_kubernetesaks && cd dynatracelab_kubernetesaks && chmod +x deploy-aks-cluster-voting-app-with-service-principal.sh";
        fi
        ###stop VM Linux
        if [[ $VM_STARTED = [N] ]]
        then
                az vm deallocate -g "$RESOURCE_GROUP" -n "$DOMAIN";
	else
                az vm run-command invoke -g "$RESOURCE_GROUP" -n "$DOMAIN" --command-id RunShellScript --scripts "service shellinabox restart";		
	        if [[ $EASYTRAVEL_ENV = [Y] ]]
        	then
			az vm run-command invoke -g "$RESOURCE_GROUP" -n "$DOMAIN" --command-id RunShellScript --scripts "/home/dynatracelab_easytraveld/start-stop-easytravel.sh start";		
	       fi 

	fi
        ###VM Linux is created and stopped - start the VM Linux from the azure portal
        ###Create VM Windows
        if [[ $WINDOWS_ENV = [Y] ]]
        then
                echo 'create vm : win'$DOMAIN'.'$LOCATION'.cloudapp.azure.com'
                az deployment group create \
                        --resource-group $RESOURCE_GROUP \
                        --template-uri https://raw.githubusercontent.com/JLLormeau/lab-environment-for-dynatrace-training/master/azuredeploy-windows.json \
                        --parameters  adminUsername="$user" virtualMachines_MyWinVM_name=MyWinVM"$X""$i" adminPasswordOrKey="$PASSWORD" dnsNameForPublicIP=win"$DOMAIN" vmSize="$SIZE_WINDOWS";
                ###add linux to the NSG Windows (for TCP POrt 22, 443, 80, 27017 Mongodb) only with windows VM
                az network nic update -g "$RESOURCE_GROUP" -n myVMNicD --network-security-group MyWinVM-nsg;
                ###Change the RDP default port to 443 (not in the script for the moment)
                #az vm run-command invoke  --command-id SetRDPPort --name MyWinVM"$X""$i" -g $RESOURCE_GROUP --parameters "RDPPORT=443";
                ###Stop VM Windows
                if [[ $VM_STARTED = [N] ]]
                then
                        az vm deallocate -g "$RESOURCE_GROUP" -n MyWinVM"$X""$i";
                fi
                ###VM Windows is created and stopped - start the VM windows from the azure portal
        fi

        ###write the az cli in the delete script for deleting all thiese resource group at the end of the training
        echo "echo "$RESOURCE_GROUP >> delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
        echo "az group delete --name "$RESOURCE_GROUP" --y" >> delete_ressourcegroup_$DOMAIN_NAME_$TIME.sh
done

echo 'END installation='`date +%Y%m%d%H%M%S`
} | tee $log
