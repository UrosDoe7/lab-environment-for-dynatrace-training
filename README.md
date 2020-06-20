# Lab environment for dynatrace training
This script permits to deploy quickly several Ubuntu VM with Docker Engine on an Azure subscription. It's usefull for a workshop. It's compatible with easytravel on docker. Usefull to deploy quickly a Dynatrace training environment.

Open your azure subscription, https://portal.azure.com/  
Open your azure cli like described here :  
![cli-azure](cli-azure.png)


**TRAINING - DEPLOY training environment for Dynatrace Lab** : Go to your Azure Cli and apply these commands
   
    cd;if [ -d "./lab-environment-for-dynatrace-training" ];then rm -rf ./lab-environment-for-dynatrace-training;fi
    git clone https://github.com/JLLormeau/lab-environment-for-dynatrace-training.git
    cd lab-environment-for-dynatrace-training;chmod +x ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
    ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
    ls
      
You can create 20 env max with Windows and Linux for dynatrace training (15 min per environment)
Or yo can create 20 Linux VM max for dynatrace workshop (5 min per VM)
Windows = Standard_B2s (2 CPU; 4GB RAM)
Linux = Standard_D1_v2 (1 CPU; 3.5 GB RAM)  
user00;windynatracelab00.uksouth.cloudapp.azure.com;dynatracelab00.uksouth.cloudapp.azure.com;*****
user01;windynatracelab01.uksouth.cloudapp.azure.com;dynatracelab01.uksouth.cloudapp.azure.com;*****
user02;windynatracelab02.uksouth.cloudapp.azure.com;dynatracelab02.uksouth.cloudapp.azure.com;*****

Linux,  direct access from a bowser (443)       : https://dynatracelab00.uksouth.cloudapp.azure.com
EasytravelDocker,  installed and started  (80)  : http://dynatracelab00.uksouth.cloudapp.azure.com
(optional) Windows,  access with mstsc (3389)   : dynatracelab00.uksouth.cloudapp.azure.com

The VM are installed and stopped.  Start the VM when you are readey on your Azure portals :
https://portal.azure.com/#blade/HubsExtension/BrowseResourceBlade/resourceType/Microsoft.Compute%2FVirtualMachines

If you install Easytravel, dy default, the mongodb is shutdown every 4 hours during 20 minutes.  
You can verify the con with this command : sudo crontab -l  
You can edit  the con with this command : sudo crontab -e  
And erase the cron with this command : sudo crontab -r  

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

at the end of the workshop, delete the labs resource groups (VM).  
  
  
**KUBERNETES LAB** : 
Prerequisite : Ubuntu VM installed
Go to the VM with putty and deploy the AKS cluster fith Azure Voting App from each VM with this command - skip the warning (installation = about 20 minutes - if you lose your session, you can run the script again):
    
    sudo apt-get install git -y
    cd;if [ -d "./dynatracelab_kubernetesaks" ];then rm -rf ./dynatracelab_kubernetesaks;fi
    git clone https://github.com/JLLormeau/dynatracelab_kubernetesaks.git
    cd dynatracelab_kubernetesaks;chmod +x deploy-aks-cluster-with-azure-voting-app.sh
    ./deploy-aks-cluster-with-azure-voting-app.sh
    ls

at the end of the workshop, delete the labs resource groups (VM, ACR et AKS).

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
