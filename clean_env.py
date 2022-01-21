#Design by JLL - Dynatrace
#########################################################################################################
#import re
import json
import requests
import calendar
import os
import urllib3
import csv
import time
import datetime
import os
import re
import sys

##################################
### Environment
##################################
tenant='https://'+str(os.getenv('MyTenant'))
token=str(os.getenv('MyToken'))
#print(tenant)
#print(token)


##################################
### variables
##################################
#disable the warning
urllib3.disable_warnings()

#API-ENV
DASHBOARDS = '/api/config/v1/dashboards'
API_MZ='/api/config/v1/managementZones'
API_MAINTENANCE='/api/config/v1/maintenanceWindows'
API_NZ='/api/v2/networkZones'
API_TAG='/api/config/v1/autoTags'



##################################
## GENERIC functions
##################################

def head_with_token(TOKEN):
    http_header = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8'
    }
    return http_header
	
# generic function GET to call API with a given uri
def queryDynatraceAPI(uri,TOKEN):
    head=head_with_token(TOKEN)
    jsonContent = None
    #print(uri)
    try:
        response = requests.get(uri,headers=head,verify=False)
        # For successful API call, response code will be 200 (OK)
        if(response.ok):
            if(len(response.text) > 0):
                jsonContent = json.loads(response.text)
        else:
            jsonContent = json.loads(response.text)
            print(jsonContent)
            errorMessage = ''
            if(jsonContent['error']):
                errorMessage = jsonContent['error']['message']
                print('Dynatrace API returned an error: ' + errorMessage)
            jsonContent = None
            raise Exception('Error', 'Dynatrace API returned an error: ' + errorMessage)
            status='failed'            
    except :
        status='failed'

    return jsonContent

# generic function POST to call API with a given uri
def postDynatraceAPI(uri, payload,TOKEN):
    head=head_with_token(TOKEN)
    jsonContent = None
    status='success'
    #print(uri)
    try:
        response = requests.post(uri,headers=head,verify=False, json=payload)
        if(response.ok):
            if(len(response.text) > 0):
                jsonContent = json.loads(response.text)
        else:
            jsonContent = json.loads(response.text)
            print(jsonContent)
            errorMessage = ''
            if (jsonContent['error']):
                errorMessage = jsonContent['error']['message']
                print('Dynatrace API returned an error: ' + errorMessage)
            jsonContent = None
            raise Exception('Error', 'Dynatrace API returned an error: ' + errorMessage)
            status='failed'
    except :
         status='failed'
    #print(jsonContent,status)
    #For successful API call, response code will be 200 (OK)
    return (jsonContent,status)


# generic function PUT to call API with a given uri
def putDynatraceAPI(uri, payload,TOKEN):
    head=head_with_token(TOKEN)
    jsonContent = None
    #print(uri)
    status='success'
    try:
        response = requests.put(uri,headers=head,verify=False, json=payload)
        if(response.ok):
            if(len(response.text) > 0):
                jsonContent = json.loads(response.text)
        else:
            jsonContent = json.loads(response.text)
            print(jsonContent)
            errorMessage = ''
            if (jsonContent['error']):
                errorMessage = jsonContent['error']['message']
                print('Dynatrace API returned an error: ' + errorMessage)
            jsonContent = None
            raise Exception('Error', 'Dynatrace API returned an error: ' + errorMessage)
            status='failed'
    except :
         status='failed'
    # For successful API call, response code will be 200 (OK)

    return (jsonContent,status)

# generic function del to call API with a given uri
def delDynatraceAPI(uri,TOKEN):
    head=head_with_token(TOKEN)
    jsonContent = None
    #print(uri)
    status='success'
    try:
        response = requests.delete(uri,headers=head,verify=False)
        if(response.ok):
            if(len(response.text) > 0):
                jsonContent = json.loads(response.text)
        else:
            jsonContent = json.loads(response.text)
            print(jsonContent)
            errorMessage = ''
            if (jsonContent['error']):
                errorMessage = jsonContent['error']['message']
                print('Dynatrace API returned an error: ' + errorMessage)
            jsonContent = None
            raise Exception('Error', 'Dynatrace API returned an error: ' + errorMessage)
            status='failed'
    except :
         status='failed'
    # For successful API call, response code will be 200 (OK)

    return (jsonContent,status)

##################################
### functions###
##################################

# dashboard to clean
def dashboard_clean(TENANT,TOKEN):
    uri=TENANT + DASHBOARDS + '?Api-Token=' +TOKEN
    print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    dashboards = datastore.get('dashboards')
    for dashboard in dashboards:
        id = dashboard.get('id')
        name = dashboard.get('name')
        owner = dashboard.get('owner')
        if owner != 'Dynatrace':
            uri = TENANT + DASHBOARDS + '/' + id + '?Api-Token=' + TOKEN
            delDynatraceAPI(uri, TOKEN)
            print('delete ' +name+ '    '+id)
    return ()

# management zones to clean
def mz_clean(TENANT,TOKEN):
    uri=TENANT + API_MZ + '?Api-Token=' +TOKEN
    print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    if datastore != []:
        apilist = datastore['values']
        for entity in apilist:
            uri = TENANT + API_MZ + '/' + entity['id'] + '?Api-Token=' + TOKEN
            print('delete ' +entity['name']+ '    '+entity['id'])
            delDynatraceAPI(uri, TOKEN)
    return ()



# maintenance windows to clean
def mw_clean(TENANT,TOKEN):
    uri=TENANT + API_MAINTENANCE + '?Api-Token=' +TOKEN
    print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    if datastore != []:
        apilist = datastore['values']
        for entity in apilist:
            uri = TENANT + API_MAINTENANCE + '/' + entity['id'] + '?Api-Token=' + TOKEN
            print('delete ' +entity['name']+ '    '+entity['id'])
            delDynatraceAPI(uri, TOKEN)
    return ()

# network zone to clean
def nz_clean(TENANT,TOKEN):
    uri=TENANT + API_NZ + '?Api-Token=' +TOKEN
    print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    if datastore != []:
        apilist = datastore['networkZones']
        for entity in apilist:
            if entity['id'] != 'default':
                uri = TENANT + API_NZ + '/' + entity['id'] + '?Api-Token=' + TOKEN
                print('delete '+entity['id'])
                delDynatraceAPI(uri, TOKEN)
    return ()
    
# auto_tag to clean
def tag_clean(TENANT,TOKEN):
    uri=TENANT + API_TAG + '?Api-Token=' +TOKEN
    print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    if datastore != []:
        apilist = datastore['values']
        for entity in apilist:
            if entity['id'] != 'default':
                uri = TENANT + API_TAG + '/' + entity['id'] + '?Api-Token=' + TOKEN
                print('delete ' +entity['name']+'  '+entity['id'])
                delDynatraceAPI(uri, TOKEN)
    return ()

#Clean
#dashboard_clean(tenant,token)
#mz_clean(tenant,token)
#mw_clean(tenant,token)
#nz_clean(tenant,token)
tag_clean(tenant,token)

