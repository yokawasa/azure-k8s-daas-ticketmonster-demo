#!/bin/sh

myaccountname=<myaccount>
myuser=<myuser>
mypass=<mypassword>
resourcegroup=<my resource group>
region=<region>

## Create PostgreSQL server account
az postgres server create --resource-group $resourcegroup --name $myaccountname --location $region --admin-user $myuser --admin-password $mypass --performance-tier Basic --compute-units 50 --version 9.6

## Configure firewall - allow all ip range
az postgres server firewall-rule create -g $resourcegroup -s $myaccountname --name AllowFullRangeIP --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

## Configure ssl enforcement disable
az postgres server update -g $resourcegroup -n $myaccountname --ssl-enforcement Disabled

