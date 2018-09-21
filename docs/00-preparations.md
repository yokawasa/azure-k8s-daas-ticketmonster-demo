# 00 - Preparations
## 1. Azure Subscripotion

You need an Azure subscription. If you don't have one, you can [sign up for an account](https://azure.microsoft.com/).


## 2. Setup for Azure Cloud Shell (Only for Azure Cloud Shell user)

### Open Azure Cloud Shell

In this hands-on labs, you're running this workthrough on [Azure Cloud Shell Bash](https://docs.microsoft.com/en-us/azure/cloud-shell/overview).

So open Azure Cloud Shell with `Base Mode`, first of all.

![](../images/cloud-shell-open-bash.png)
> Note: Another option is to use the full screen Azure Cloud Shell at https://shell.azure.com/.

The first time you connect to the Azure Cloud Shell you will be prompted to setup an Azure File Share that you will persist the environment.
![](../images/cloud-shell-welcome.png)

Click the "Bash (Linux)" option, and select the Azure Subscription and click "Create storage":
![](../images/cloud-shell-no-storage-mounted.png)

After a few seconds, your storage account will be created. Azure Cloud Shell is ready to use


### Verify Subscription

Run the command az account list -o table
```
$ az account list -o table

Name                             CloudName    SubscriptionId                        State    IsDefault
-------------------------------  -----------  ------------------------------------  -------  -----------
Visual Studio Premium with MSDN  AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  True
Another sub1                     AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  False
Another sub2                     AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  False
Another sub3                     AzureCloud   xxxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx  Enabled  False
```

If you have more than subscription, make sure that subscription is set as default using the subscription name:

```
$ az account set -s 'Visual Studio Premium with MSDN'
```

## 3. Azure-CLI (NO NEED for Azure Cloud Shell User)

You need azure-cli command line tool to run this workthrough on Linux or Mac OS (Maybe Bash on Windows too but not tested yet). 
Suppose you want to operate locally and you don't yet have azure-cli installed on your local environment, you can install the azure-cli like this:

```
sudo pip install -U azure-cli
```

## 4. Service Principal

Create a Service Principal with the following Azure CLI command:
```
az ad sp create-for-rbac --role Contributor
```
Output should be similar to the following. Take note of the appId, password, and tenant values, which you use in creating Azure Kubernetes Cluster

```
{
  "appId": "353bfe4e-e98c-4d78-adb1-947d45296caa",        # Client ID "displayName": "azure-cli-2018-04-28-02-12-13",
  "name": "http://azure-cli-2018-04-28-02-12-13",
  "password": "3d4f4303-ca12-4c29-94a7-e5bde0c1f8c1",     # Client Secret
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db47"        # Tenant Id
}
```

## 5. (Optional) Custom Container images for a Ticket-Monster App
You can basically use a default container image ([yoichikawasaki/wildfly-ticketmonster-ha:1.1](https://hub.docker.com/r/yoichikawasaki/wildfly-ticketmonster-ha/)) for the Ticket-Monster app. However if you want to use your custom app, create a container image and push it to a container registry. Once you have a container image registered in the registry, replace the container image part of kubernetes/wildfly-server-2.yaml file with your container image:tag name.

```
containers:
- name: wildfly
    image: yoichikawasaki/wildfly-ticketmonster-ha:1.1
```


---
[Top](../README.md) | [Next](01-create-aks-cluster.md)