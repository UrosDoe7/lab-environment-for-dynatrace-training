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
paastoken=str(os.getenv('PaasToken'))
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
API_SLO='/api/v2/slo'
API_SYNT='/api/v1/synthetic/monitors'
API_TOKEN='/api/v1/tokens'



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
    print('clean dashboard')
    uri=TENANT + DASHBOARDS + '?Api-Token=' +TOKEN
    #print(uri)
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
    print('clean mz')
    uri=TENANT + API_MZ + '?Api-Token=' +TOKEN
    #print(uri)
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
    print('clean mw')
    uri=TENANT + API_MAINTENANCE + '?Api-Token=' +TOKEN
    #print(uri)
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
    print('clean nz')
    uri=TENANT + API_NZ + '?Api-Token=' +TOKEN
    #print(uri)
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
    print('clean autotag')
    uri=TENANT + API_TAG + '?Api-Token=' +TOKEN
    #print(uri)
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

# slo to clean
def slo_clean(TENANT,TOKEN):
    print('clean slo')
    uri=TENANT + API_SLO + '?Api-Token=' +TOKEN
    #print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    if datastore != []:
        apilist = datastore['slo']
        for entity in apilist:
            if entity['id'] != 'default':
                uri = TENANT + API_SLO + '/' + entity['id'] + '?Api-Token=' + TOKEN
                print('delete ' +entity['name']+'  '+entity['id'])
                delDynatraceAPI(uri, TOKEN)
    return ()

# synthetic to clean
def synth_clean(TENANT,TOKEN):
    print('clean synthetic')
    uri=TENANT + API_SYNT + '?Api-Token=' +TOKEN
    #print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    if datastore != []:
        apilist = datastore['monitors']
        for entity in apilist:
                uri = TENANT + API_SYNT + '/' + entity['entityId'] + '?Api-Token=' + TOKEN
                print('delete ' +entity['name']+'  '+entity['entityId'])
                delDynatraceAPI(uri, TOKEN)
    return ()

# token to clean
def token_clean(TENANT,TOKEN):
    print('clean token')
    uri=TENANT + API_TOKEN + '?Api-Token=' +TOKEN
    print(uri)
    datastore = queryDynatraceAPI(uri, TOKEN)
    #print(datastore)
    if datastore != []:
        apilist = datastore['values']
        for entity in apilist:
            if not token.startswith(entity['id']) and not paastoken.startswith(entity['id']) and not entity['name'].startswith('donotdelete'):
                print(entity['id'], entity['name'])
                uri = TENANT + API_TOKEN + '/' + entity['id'] + '?Api-Token=' + TOKEN
                print('delete ' +entity['name']+'  '+entity['id'])
                delDynatraceAPI(uri, TOKEN)
    return ()

#Clean
print(tenant)
print()
#dashboard_clean(tenant,token)
#mz_clean(tenant,token)
#mw_clean(tenant,token)
#nz_clean(tenant,token)
#tag_clean(tenant,token)
#slo_clean(tenant,token)
#synth_clean(tenant,token)
#token_clean(tenant,token)
#manque custom event for alert, mda
