#!/bin/bash

echo "step 1 start"
sh remote-start-stop-easytravel.sh restart

echo "sleep 2m"
sleep 2m

echo "sleep issue"
sh remote-remote-start-stop-easytravel.sh issue

echo "sleep 5m"
sleep 5m

echo "sleep restart"
sh remote-start-stop-easytravel.sh restart

echo "sleep 5m"
sleep 5m

echo "sleep restartmongo"
sh remote-start-stop-easytravel.sh restartmongo

echo "sleep 5m"
sleep 5m

echo "sleep restart"
sh remote-start-stop-easytravel.sh restart
