# 01 - Create AKS Cluster

## 1. Create AKS Cluster

First of all, enable AKS preview for your Azure subscription by running the following command (Only in preview period):
```
az provider register -n Microsoft.ContainerService
```
In addition, execute the following commands which are needed in case that it's the first time to manage network & compute resources with your subscription:
```
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
```

Then, create resource group (Resource group named RG-aks in eastus region):
```
RESOURCE_GROUP='your resource group (e.g., "RG-aks")'
LOCATION='your location (e.g.,"eastus")'

az group create --name $RESOURCE_GROUP --location $LOCATION
```

Create AKS Cluster (generate a new SSH key):
```
az aks create --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --kubernetes-version 1.11.1 \
    --node-vm-size Standard_D2_v2 \
    --node-count 3 \
    --service-principal $SP_CLIENT_ID \
    --client-secret $SP_CLIENT_SECRET \
    --enable-addons http_application_routing \
    --generate-ssh-keys
```

If you already have a ssh key generated, specify your SSH key with `--ssh-key-value` option instead of `--generate-ssh-keys` in creating AKS Cluster:
```
SSH_KEY='~/.ssh/id_rsa_aks.pub'

az aks create --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --kubernetes-version 1.11.1 \
    --node-vm-size Standard_D2_v2 \
    --node-count 3 \
    --service-principal $SP_CLIENT_ID \
    --client-secret $SP_CLIENT_SECRET \
    --enable-addons http_application_routing \
    --ssh-key-value $SSH_KEY
```

## 2. Install the kubectl CLI and connect to the cluster with kubectl (NO NEED for Azure Cloud Shell user)

If you want to install it locally, run the following command:
```
az aks install-cli
```
[note]
You can skip this installation if you're running this workthrough on [Azure Cloud Shell Bash](https://docs.microsoft.com/en-us/azure/cloud-shell/overview) where the kubeclt is pre-installed.

Then, run the following command to configure kubectl to connect to your Kubernetes cluster, run the following command:
```
RESOURCE_GROUP='your resource group (e.g., "RG-aks")'
CLUSTER_NAME='your AKS cluster name (e.g., "myAKSCluster")'

az aks get-credentials --resource-group=$RESOURCE_GROUP --name=$CLUSTER_NAME
```

Finally, check if you can connect to the cluster by running the following command:
```
kubectl cluster-info

(Sample OUTPUT)
Kubernetes master is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443
Heapster is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy
```

Get the list of node in your cluster
```
kubectl get nodes

(SAMPLE OUTPUT)
NAME                       STATUS    ROLES     AGE       VERSION
aks-nodepool1-40291275-0   Ready     agent     21m       v1.11.1
aks-nodepool1-40291275-1   Ready     agent     21m       v1.11.1
aks-nodepool1-40291275-2   Ready     agent     21m       v1.11.1
```
