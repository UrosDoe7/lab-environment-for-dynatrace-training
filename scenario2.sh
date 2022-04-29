#!/bin/bash
#design by JLLormeau Dynatrace
# version beta

. ./env.sh
response="no"
export END_ENV=$(($NBENV + $START_ENV))
echo END_ENV=$END_ENV


until [ $response == "restartmongo" || $response == "issue" ]
	do
		read  -p "start | stop | restart | startloadgen | stoploadgen | restartmongo | stopmongo | status | issue  " response
	done


i=$START_ENV
while [ $i -le $END_ENV ]
do
	echo $i
	if [ $i -lt 5 ]
	then
		X='0' #from 00 to 04
		LOCATION=$LOCATION1      
	
		echo "Stop mongo"
		#ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
		echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
		ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh '$value &

	fi
	if [ $i -ge 5 ] | [ $i -gt 10 ] 
	then
		X='0' #from 05 to 09
		LOCATION=$LOCATION2
		#ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
		echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
		ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh status' &


	fi
	if [ $i -ge 10 ] | [ $i -gt 15 ] 
	then
		X='' #from 10 to 14
		LOCATION=$LOCATION3
		#ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
		echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
		ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh status' &        

	fi
	if [ $i -ge 15 ] | [ $i -gt 20 ] 
	then
		X='' #from 10 to 20
		LOCATION=$LOCATION4
		#ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh restartmongo' &
		echo 'Stop Mongo with ssh user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' 
		ssh -oStrictHostKeyChecking=no 'user'$X$i'@'$DOMAIN_NAME$X$i'.'$LOCATION'.cloudapp.azure.com' '/home/dynatracelab_easytraveld/start-stop-easytravel.sh status' &

	fi     
	i=$(($i + 1))
done
