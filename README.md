# Lab environment for dynatrace training
This script permits to deploy quickly several Ubuntu VM with Docker Engine on an Azure subscription. It's usefull for a workshop and Dynatrace Training. Several options are available to deploy and start automatically easytravel or to do the workshop on Kubernetes with Azure Vote App. 

Open your azure subscription, https://portal.azure.com/ 
Open your azure cli like described here :  
![cli-azure](cli-azure.png)


**TRAINING DYNATRACE**  
**DEPLOY training environment for Dynatrace Lab** : Go to your Azure Cli and apply these commands
   
    cd;if [ -d "./lab-environment-for-dynatrace-training" ];then rm -rf ./lab-environment-for-dynatrace-training;fi
    git clone https://github.com/JLLormeau/lab-environment-for-dynatrace-training.git
    cd lab-environment-for-dynatrace-training;chmod +x ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
    wget https://github.com/dynatrace-oss/dynatrace-monitoring-as-code/releases/latest/download/monaco-linux-amd64;
    mv monaco-linux-amd64 monaco;chmod +x monaco
    ./azure-cli-deploy-vm-windows-and-linux-for-training-dynatrace.sh
      
Max 20 environments.

0) config env : training name                          =dynatracelab<customer>  # Must be unique for the training and without special character 
1) config env : password                               =xxxxxxxx 
2) config env : value fisrt env                        =00 
3) config env : nbr total env                          =2
4) add env : windows VM to env                         =N  
5) add env : easytravel installed                      =Y  
6) add env : cron to stop Mongo at 11 H GMT            =Y  #optionnal, generate a problem at 11 GMT  
7) stop Mongo : hour (GMT) of Mongo shutdown           =11 
8) full configuration : OneAgent + run Monaco          =Y  #to deploy the full the OneAgent and the full monaco configuration. 
   
9) start env : VM started after installation           =N
A) apply and deploy the VM - (Ctrl/c to quit)

Input Selection (0, 1, 2, ..., 8, 9  or A):

In case you select 8)full configuration, you will have this menu: 

0) Tenant                               =yyyy.jzq02463.live.dynatrace.com
1) API Token                            =dt0c01.abcdefghij.abcdefghijklmn
2) PaaS Token                           =dt0c01.abcdefghij.abcdefghijklmn
3) List of emails                               =user1@user1.com user2@user2.com
A) apply and deploy the VM - (Ctrl/c to quit)
   


   

