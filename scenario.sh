#!/bin/bash

sh start-stop-easytravel.sh start

sleep 2m

sh start-stop-easytravel.sh issue

sleep 5m

sh start-stop-easytravel.sh restart

sleep 5m

sh start-stop-easytravel.sh restartmongo

sleep 5m

sh start-stop-easytravel.sh restart
