# Lab environment for dynatrace training
This script permits to deploy quickly several Ubuntu VM with Docker Engine on an Azure subscription. It's usefull for a workshop. It's compatible with easytravel on docker. Usefull to deploy quickly a Dynatrace training environment.

Open your azure subscription, https://portal.azure.com/  
Open your azure cli like described here :  
![cli-azure](cli-azure.png)


**TRAINING - DEPLOY env with Windows & Linux Azure VM** : Go to your Azure Cli and apply these commands
- linux -> 5 m per VM
- linux + windows -> 15 minutes per Env   

    cd;if [ -d "./lab-environment-for-dynatrace-training" ];then rm -rf ./lab-environment-for-dynatrace-training;fi
    git clone https://github.com/JLLormeau/lab-environment-for-dynatrace-training.git
    cd lab-environment-for-dynatrace-training;chmod +x ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
    ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
    ls
      
You can create several 20 env max with Windows and Linux for dynatrace Training
Windows = Standard_B2s (2 CPU; 4GB RAM)
Linux = Standard_D1_v2 (1 CPU; 3.5 GB RAM)  
user00;windynatracelab00.uksouth.cloudapp.azure.com;dynatracelab00.uksouth.cloudapp.azure.com;*****
user01;windynatracelab01.uksouth.cloudapp.azure.com;dynatracelab01.uksouth.cloudapp.azure.com;*****
user02;windynatracelab02.uksouth.cloudapp.azure.com;dynatracelab02.uksouth.cloudapp.azure.com;*****

Linux access from the web (443) : https://dynatracelab00.uksouth.cloudapp.azure.com
Easytravel access (80) : http://dynatracelab00.uksouth.cloudapp.azure.com
Windows access from the mstsc (3389) : dynatracelab00.uksouth.cloudapp.azure.com

**EASYTRAVEL LAB** : 
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
    cd;if [ -d "./dynatracelab_azure-voting-app-redis" ];then rm -rf ./dynatracelab_azure-voting-app-redis;fi
    git clone https://github.com/JLLormeau/dynatracelab_azure-voting-app-redis.git
    cd dynatracelab_azure-voting-app-redis;chmod +x deploy-aks-cluster-with-azure-voting-app.sh
    ./deploy-aks-cluster-with-azure-voting-app.sh
    ls

at the end of the workshop, delete the labs resource groups (VM, ACR et AKS).

**DELETE LABS RESOURCE GROUP** : Go to your Azure Cli and apply these commands (follow the instruction) you will only delete your labs resource groups.

    cd;cd azure-cli-deploy-vm-for-workshop;chmod +x azure-cli-delete-labs-resource-group.sh
    ./azure-cli-delete-labs-resource-group.sh
    ls

**DEPECATED - WORKSHOP - DEPLOY Ubuntu Azure VM** : Go to your Azure Cli and apply these commands (quick -> about 3 minutes per VM):   

    cd;if [ -d "./lab-environment-for-dynatrace-training" ];then rm -rf ./lab-environment-for-dynatrace-training;fi
    git clone https://github.com/JLLormeau/lab-environment-for-dynatrace-training.git
    cd lab-environment-for-dynatrace-training;chmod +x azure-cli-deploy-vm-for-workshop.sh
    ./azure-cli-deploy-vm-for-workshop.sh
    ls
      
You can create several ubuntu VM with the size = Standard_D1_V2 (1 CPU; 3.5GB)
Here is the example for 3 VM with the default hostnames and credentials:  
VM0 : dynatracelab2019120214002300.westeurope.cloudapp.azure.com & user=user00 & Pwd=*****  
VM1 : dynatracelab2019120214002301.westeurope.cloudapp.azure.com & user=user01 & Pwd=*****  
VM2 : dynatracelab2019120214002302.westeurope.cloudapp.azure.com & user=user02 & Pwd=*****  
