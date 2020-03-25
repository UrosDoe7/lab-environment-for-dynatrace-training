  #!/bin/bash
echo "Project name (example dynatracelab20191202162044) ?"
read DOMAIN_NAME
echo "How many VM ?"
read NBVM
echo "type AKS (Y|N) ?"
read AKS
if [ $AKS = "Y" ] || [ $AKS = "y" ]
then
        for ((i=0; i<$NBVM; ++i));
                do
                        USER='USER0'$i
                        VM_RESOURCE_GROUP=$DOMAIN_NAME'0'$i
                        ACR_RESOURCE_GROUP='acr'$DOMAIN_NAME'0'$i
                        AKS_RESOURCE_GROUP='MC_'$ACR_RESOURCE_GROUP'_akscluster_westeurope'
                        echo "delete resource group "$VM_RESOURCE_GROUP
                        az group delete --name $VM_RESOURCE_GROUP --y
                        echo "delete resource group "$ACR_RESOURCE_GROUP
                        az group delete --name $ACR_RESOURCE_GROUP --y
                        echo "delete resource group "$AKS_RESOURCE_GROUP
                        az group delete --name $AKS_RESOURCE_GROUP --y
                done
else
        for ((i=0; i<$NBVM; ++i));
                do
                        USER='0'$i
                        VM_RESOURCE_GROUP=$DOMAIN_NAME$USER
                        echo "delete resource group "$VM_RESOURCE_GROUP
                        az group delete --name $VM_RESOURCE_GROUP --y
                done
fi
