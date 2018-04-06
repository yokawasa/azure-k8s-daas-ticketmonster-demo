# Create AKS Cluster

## 1. Create AKS Cluster
First of all, update latest azure-cli in case that you're operating locally. This step can be skipped if you're using [Azure Cloud Shell](https://docs.microsoft.com/en-us/azure/cloud-shell/overview):
```
pip install -U azure-cli
```

Enable AKS preview for your Azure subscription by running the following command (Only in preview period):
```
az provider register -n Microsoft.ContainerService
```

Create resource group (Resource group named RG-aks in eastus region):
```
az group create --name RG-aks --location eastus
```

Create AKS Cluster ( a cluster named myAKSCluster in a resource group named RG-aks with cluster node count=1 and a new SSH key):
```
az aks create --resource-group RG-aks --name myAKSCluster --node-count 1 --generate-ssh-keys
```
If you already have a ssh key generated, specify your SSH key with --ssh-key-value option instead of --generate-ssh-keys in creating AKS Cluster:
```
az aks create --resource-group RG-aks --name myAKSCluster --node-count 1 --ssh-key-value ~/.ssh/id_rsa_aks.pub
```

## 2. Install the kubectl CLI and connect to the cluster with kubectl

If you want to install it locally, run the following command:
```
az aks install-cli
```
Then, run the following command to configure kubectl to connect to your Kubernetes cluster, run the following command:
```
az aks get-credentials --resource-group=RG-aks --name=myAKSCluster
```
Check if you can connect to the cluster by running the kubectl command:
```
kubectl cluster-info

(Sample OUTPUT)
Kubernetes master is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443
Heapster is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/heapster/proxy
KubeDNS is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
kubernetes-dashboard is running at https://myaksclust-rg-aks-87c7c7-d177390a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kubernetes-dashboard/proxy
```

```
kubectl get nodes

(SAMPLE OUTPUT)
NAME                       STATUS    ROLES     AGE       VERSION
aks-nodepool1-17576119-0   Ready     agent     6m        v1.7.7
```
