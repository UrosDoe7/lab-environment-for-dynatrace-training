#!/bin/bash
#design by JLLormeau Dynatrace
# version beta

. env.sh
response=0
echo $START_ENV $START_ENV

#until [ "$response" -eq "1"  -o  "$response" -eq "2"  ]
#	do
#		read  -p "\"1\" = stop mongo + restart 10 min later OR \"2\" = large memory leak + restart 10 min later  " response
#	done


for ((i=0+$START_ENV; i<$START_ENV+$START_ENV; ++i));
do
        if (( $i < 5 ))
        then
                X='0' #from 00 to 04
                LOCATION=$LOCATION1      
                #ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
                echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
                ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh status' &
                
        fi
        if (( $i >= 5 ))&&(($i < 10))
        then
                X='0' #from 05 to 09
                LOCATION=$LOCATION2
                #ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
                echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
                ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh status' &


        fi
        if (( $i >= 10 ))&&(($i < 15))
        then
                X='' #from 10 to 14
                LOCATION=$LOCATION3
                #ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
                echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
                ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh status' &        
        
        fi
        if (( $i >= 15 ))&&(($i < 20))
        then
                X='' #from 10 to 20
                LOCATION=$LOCATION4
                #ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
                echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
                ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh status' &

        fi
done
