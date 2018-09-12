#!/bin/sh
AZURE_CLIENT_ID='Your Service Principal Client ID'
AZURE_CLIENT_SECRET='Your Service Principal Client Secret'
AZURE_TENANT_ID='Your Service Principal Tenant ID'

AZURE_SUBSCRIPTION_ID=$(az account show --query id --output tsv | sed -e "s/[\r\n]\+//g" )

helm repo add azure https://kubernetescharts.blob.core.windows.net/azure

helm install azure/open-service-broker-azure --name osba --namespace osba \
    --set azure.subscriptionId=$AZURE_SUBSCRIPTION_ID \
    --set azure.tenantId=$AZURE_TENANT_ID \
    --set azure.clientId=$AZURE_CLIENT_ID \
    --set azure.clientSecret=$AZURE_CLIENT_SECRET
