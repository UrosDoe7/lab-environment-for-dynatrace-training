#!/bin/bash
#design by JLLormeau Dynatrace
# version beta

. ../env.sh
DIR_MONACO="template-monaco-for-easytravel"
response=no

while [ "$response" !=  "$MyTenant"  ]
	do
		read  -p "clean ALL configurations for this tenant $MyTenant - enter the full name $MyTenant :  " response
	done

python clean-env.py


cd ..
for i in {0..19}
do
	if [[ $i -lt 10 ]]; then 
		p=0
	else
		p=''	
	fi	
		echo easytravel$p$i
		echo `sed -i 's/Appname/easytravel'$p$i'/g' $DIR_MONACO/Delete/delete.yaml;./monaco deploy -e=environments.yaml -s=free_trial $DIR_MONACO/Delete;sed -i 's/easytravel'$p$i'/Appname/g' $DIR_MONACO/Delete/delete.yaml`
done
