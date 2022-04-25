#!/bin/bash
#design by JLLormeau Dynatrace

. ../env.sh


while [ "$response" !=  "disable" ]   OR  [ "$response" !=  "enable"  ]
	do
		read  -p "enable or disable " response
	done

python process_mongo_availability.py $response
