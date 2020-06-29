# Lab environment for dynatrace training
This script permits to deploy quickly several Ubuntu VM with Docker Engine on an Azure subscription. It's usefull for a workshop. It's compatible with easytravel on docker. Usefull to deploy quickly a Dynatrace training environment.

Open your azure subscription, https://portal.azure.com/  
Open your azure cli like described here :  
![cli-azure](cli-azure.png)



**TRAINING DYNATRACE**  
**DEPLOY training environment for Dynatrace Lab** : Go to your Azure Cli and apply these commands
   
    cd;if [ -d "./lab-environment-for-dynatrace-training" ];then rm -rf ./lab-environment-for-dynatrace-training;fi
    git clone https://github.com/JLLormeau/lab-environment-for-dynatrace-training.git
    cd lab-environment-for-dynatrace-training;chmod +x ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
    ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
    ls
      
Max training environment = 20 (for that you need all your quota on the region ; france central, west europe, north europe and uk south)  
For each environment : 
   - 1 VM Linux UBUNTU = Standard_D1_v2 (1 CPU; 3.5 GB RAM)  
   - Option on the Linux VM 
      * easytravel docker insalled and started  
      * crontab to stop mongodb 20 minutes every day and generated problems  
      * kubernetes : script to deploy Azure Vote App on AKS for the workshop Kubernetes (need a Service Principal for the authentication)   
   - Option on the training environment
      * 1 VM Windows 10 = Standard_B2s (2 CPU; 4GB RAM) for these workshop : LoadGen, Android and Plugin Python 

With default configuration the script will deploy 2 environments with all options enabled : 
user00;dynatracelab00.francecentral.cloudapp.azure.com;windynatracelab00.francecentral.cloudapp.azure.com;*****  
user01;dynatracelab01.francecentral.cloudapp.azure.com;windynatracelab01.francecentral.cloudapp.azure.com;*****  

Linux,  direct access from a bowser (443)       : https://dynatracelab00.francecentral.cloudapp.azure.com
EasytravelDocker,  installed and started  (80)  : http://dynatracelab00.francecentral.cloudapp.azure.com
(optional) Windows,  access with mstsc (3389)   : windynatracelab00.francecentral.cloudapp.azure.com

By default, the VM are installed and stopped.  Start the VM when you are readey on your Azure portals :
https://portal.azure.com/#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Compute%2FVirtualMachines

By default, the crontab is configured to stop mongodb for 20 minutes at 15 H GMT:
To show the cron, use this command :   sudo crontab -l  
To edit the cron, this command :       sudo crontab -e  
And to erase the cron, this one :      sudo crontab -r  

At the end of the workshop, to delete the labs resource groups, execute the script which has been automaticaly generated locally on your Azure Cli bash /home/azureuser/lab-environment-for-dynatrace-training


**INSTALL the Kubernetes environment**  : Go to your Linux VM with the option "Kubernetes : script to deploy Azure Vote App on AKS "= Enabled (see above) 
To deploy the Azure Vote App on your Azure subscription use this script with these 3 parameters :  
     
    /home/dynatracelab_kubernetesaks/deploy-aks-cluster-with-azure-voting-app.sh $APPID $PASSWORD $TENANT

Prerequisiste : 
   - you need quota on eastus and eastus2  
   - you need a Service Principal with $APPID $PASSWORD and $TENANT to connect to your Azure Subscription and create the AKS for Azure Vote App.    
You can use the same Service Principal for all the Azure Vote App deployments.  
Go to your Azure Cli Bash and use this az command to create your Service Principal:   

    az ad sp create-for-rbac --name MyServicePrincipalNameforLabKube

more detail about Azure Service Principal : https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli  
more information on Auze Vote App : https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-prepare-app  

At the end of the workshop, to delete the labs resource groups on each AKS, execute the script which has been automaticaly generated locally on each VM on /home/dynatracelab_kubernetesaks/  

  
  
######################################################################################  
**DEPRECATED - EASYTRAVEL LAB** : 
Prerequisite : Ubuntu VM installed
Go to the VM with putty and deploy easytravel on each VM with these commands (installation = about 2 minutes):   
   
    git clone https://github.com/JLLormeau/dynatracelab_easytraveld.git
    cd dynatracelab_easytraveld
    docker-compose up -d
    docker-compose ps

In thise example, we create 3 easytravel application :  
http://dynatracelab2019120214002300.westeurope.cloudapp.azure.com  
http://dynatracelab2019120214002301.westeurope.cloudapp.azure.com  
http://dynatracelab2019120214002302.westeurope.cloudapp.azure.com  

to restart easytravel use these commands on each VM :  
    
    cd dynatracelab_easytraveld
    docker-compose down
    docker-compose up -d
    docker-compose ps

at the end of the workshop, delete the labs resource groups (VM)

**DEPRECATED - DELETE LABS RESOURCE GROUP** : Go to your Azure Cli and apply these commands (follow the instruction) you will only delete your labs resource groups.

    cd;cd azure-cli-deploy-vm-for-workshop;chmod +x old-azure-cli-delete-labs-resource-group.sh
    ./old-azure-cli-delete-labs-resource-group.sh
    ls

**DEPRECATED - WORKSHOP - DEPLOY Ubuntu Azure VM** : Go to your Azure Cli and apply these commands (quick -> about 3 minutes per VM):   

    cd;if [ -d "./lab-environment-for-dynatrace-training" ];then rm -rf ./lab-environment-for-dynatrace-training;fi
    git clone https://github.com/JLLormeau/lab-environment-for-dynatrace-training.git
    cd lab-environment-for-dynatrace-training;chmod +x old-azure-cli-deploy-vm-for-workshop.sh
    ./old-azure-cli-deploy-vm-for-workshop.sh
    ls
      
You can create several ubuntu VM with the size = Standard_D1_V2 (1 CPU; 3.5GB)
Here is the example for 3 VM with the default hostnames and credentials:  
VM0 : dynatracelab2019120214002300.westeurope.cloudapp.azure.com & user=user00 & Pwd=*****  
VM1 : dynatracelab2019120214002301.westeurope.cloudapp.azure.com & user=user01 & Pwd=*****  
VM2 : dynatracelab2019120214002302.westeurope.cloudapp.azure.com & user=user02 & Pwd=*****  
