#  04 - Provision, bind and consume Azure Database for PostgreSQL using OSBA

## Install Open Service Broker for Azure

Open Service Broker for Azure (OSBA) is the open source, Open Service Broker-compatible API server that provisions managed services in Azure. As prerequisites, you need to install Service Catalog onto your Kubernetes cluster.

### Install Helm Client and Tiller (Pre-requiste, NO NEED for Azure Cloud Shell user)

First of all, install Helm Client. 

```
# Option: Install Helm client from script
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Option: Install Helm client from Homebrew (MacOS)
brew install kubernetes-helm
```
Refer to [Installing Helm](https://docs.helm.sh/using_helm/#installing-helm) for more detail on Helm installation.


### Install and upgrade Tiller (Helm Server) Component in AKS cluster

Then, install and upgrade Tiller (Helm server) components in kubernetes cluster. Tiller is the in-cluster server component of Helm. By default, helm init installs the Tiller pod into the kube-system namespace, and configures Tiller to use the default service account. Tiller will need to be configured with cluster-admin access to properly install Service Catalog

```
helm init --upgrade
```

### Install Service Catalog using Helm Chart

Add the Service Catalog chart to the Helm repository
```
helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
```

Grant Helm permission to admin your cluster, so it can install service-catalog:
```
kubectl create clusterrolebinding tiller-cluster-admin \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:default
```

Install service catalog with Helm chart
```
helm install svc-cat/catalog \
    --name catalog \
    --namespace catalog
```

Check if it's deployed.
echo "Wait until servicecatalog appears in the output of \"kubectl get apiservice\""
```
helm ls  
# or 'helm ls --all catalog'
```
Verify that `servicecatalog` appears in the output of "kubectl get apiservice"
```
kubectl get apiservice -w
```
Sample Output:

```
NAME                                    AGE
v1.                                     21d
v1.apps                                 21d
v1.authentication.k8s.io                21d
v1.authorization.k8s.io                 21d
v1.autoscaling                          21d
v1.batch                                21d
v1.networking.k8s.io                    21d
v1.rbac.authorization.k8s.io            21d
v1.storage.k8s.io                       21d
v1alpha1.admissionregistration.k8s.io   16d
v1alpha2.config.istio.io                21d
v1beta1.admissionregistration.k8s.io    21d
v1beta1.apiextensions.k8s.io            21d
v1beta1.apps                            21d
v1beta1.authentication.k8s.io           21d
v1beta1.authorization.k8s.io            21d
v1beta1.batch                           21d
v1beta1.certificates.k8s.io             21d
v1beta1.events.k8s.io                   21d
v1beta1.extensions                      21d
v1beta1.policy                          21d
v1beta1.rbac.authorization.k8s.io       21d
v1beta1.servicecatalog.k8s.io           4d      <<<< This one!!
v1beta1.storage.k8s.io                  21d
v1beta2.apps                            21d
v2beta1.autoscaling                     21d
```

In additioin, check Service Catalog Pods' running status:
```
kubectl get pods --namespace catalog

(Output Example)
NAME                                                     READY     STATUS    RESTARTS   AGE
po/catalog-catalog-apiserver-5999465555-9hgwm            2/2       Running   4          9d
po/catalog-catalog-controller-manager-554c758786-f8qvc   1/1       Running   11         9d
```

Refer to [Install Service Catalog](https://docs.microsoft.com/en-us/azure/aks/integrate-azure#install-service-catalog) for more detail on Service Catalog installation.

### Install Service Catalog CLI

Service Catalog (svcat) CLI is very useful CLI tool in managing Service Catalog. 

```
curl -sLO https://servicecatalogcli.blob.core.windows.net/cli/latest/$(uname -s)/$(uname -m)/svcat

# Make the binary executable
chmod +x ./svcat

# Move the binary to a directory on your PATH (e.g., $HOME/bin)
mv svcat $HOME/bin
```

Refer to [Installing the Service Catalog CLI](https://github.com/kubernetes-incubator/service-catalog/blob/master/docs/install.md#installing-the-service-catalog-cli) for more detail on Service Catalog CLI installation.

### Install Open Service Broker for Azure (OSBA) using Helm Chart

Get your service principal that you created in [the preparation step](00-preparations.md) and use them for either `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID` variable value below, then install OSBA using Helm chart like this below:

```
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
```

Check if OSBA Pods are ready and running:
```
kubectl get pods --namespace osba -w

(Output Example)
NAME                                           READY     STATUS    RESTARTS   AGE
po/osba-azure-service-broker-8495bff484-7ggj6   1/1       Running   0          9d
po/osba-redis-5b44fc9779-hgnck
```


Refer to [Install Open Service Broker for Azure](https://docs.microsoft.com/en-us/azure/aks/integrate-azure#install-open-service-broker-for-azure) for more detail on OSBA installation


## Provision and bind Azure Database for PostgreSQL using OSBA

### Provision an instance of the PostgreSQL Service

First of all, open `kubernetes/postgres-instance.yaml` and make sure if `location` and `resourceGroup` parameters are the same as the one you careated for AKS cluster
```yaml
apiVersion: servicecatalog.k8s.io/v1beta1
kind: ServiceInstance
metadata:
  name: my-postgresql-instance
  namespace: default
spec:
  clusterServiceClassExternalName: azure-postgresql-9-6
  clusterServicePlanExternalName: general-purpose
  parameters:
    location: eastus                    <<<< HERE
    resourceGroup: RG-aks               <<<< HERE
    sslEnforcement: disabled
    extensions:
    - uuid-ossp
    - postgis
    firewallRules:
    - name: "AllowFromAzure"
      startIPAddress: "0.0.0.0"
      endIPAddress: "0.0.0.0"
    cores: 2
    storage: 5
    backupRetention: 7
```

Then, run the following command to create postgresql instance
```
kubectl create -f kubernetes/postgres-instance.yaml
```

you can get postgresql's provisioning status via `svcat` command: 
```
svcat get instances
           NAME            NAMESPACE          CLASS                PLAN            STATUS
+------------------------+-----------+----------------------+-----------------+--------------+
  my-postgresql-instance   default     azure-postgresql-9-6   general-purpose   Provisioning 
```

The status above is `Provisioning`. Please wait until the status changes to `Ready`.

### Bind the instance of the PostgreSQL Service

```
kubectl create -f kubernetes/postgres-binding.yaml
```
Sample Output:

```
svcat get brokers
  NAME                               URL                                STATUS
+------+--------------------------------------------------------------+--------+
  osba   http://osba-open-service-broker-azure.osba.svc.cluster.local   Ready
```

### Update YAML for Wildfly app in  Kubernetes cluster to consume the PostgreSQL service via OSBA
```
kubectl apply -f kubernetes/wildfly-server-2.yaml --record
```

Check if new Wildfly Pod is running
```
kubectl get po -l context=AKSDemo

(Sample Output)
NAME                         READY     STATUS    RESTARTS   AGE
modcluster-845fc656b-nm8tl   1/1       Running   0          1h
postgres-7c95f9bdf7-mr72k    1/1       Running   0          1h
wildfly-7df855b4c8-7sfxn     1/1       Running   0          1m   <<<
```

In addition, access Ticket-Monster application and see if it's successfully running by actually booking some Tickets:
```
open http://<modcluster external ip>/ticket-monster/
```

Finally, unprovision PostgreSQL Pod, service and secret which are no longer needed
```
kubectl delete -f kubernetes/postgres-service.yaml
kubectl delete -f kubernetes/postgres.yaml
kubectl delete -f kubernetes/postgres-secret.yaml
```

**[NOTE]**
You don't want to do this but in case that you want to delete your provisioned PostgreSQL instances & binding, you can delete actual Azure Database for PostgreSQL instance as well as Kubernetes objects for them with this: 
```
kubectl delete -f kubernetes/postgres-binding.yaml
kubectl delete -f kubernetes/postgres-instance.yaml
```

## Useful Links
- [Installing Helm](https://docs.helm.sh/using_helm/#installing-helm)
- [Install Service Catalog](https://docs.microsoft.com/en-us/azure/aks/integrate-azure#install-service-catalog)
- [Install Open Service Broker for Azure](https://docs.microsoft.com/en-us/azure/aks/integrate-azure#install-open-service-broker-for-azure)
- [Parametes of Broker for Azure Database for PostgreSQL](https://github.com/Azure/open-service-broker-azure/blob/master/docs/modules/postgresql.md)
- [Azure Database for PostgreSQL](https://azure.microsoft.com/en-us/services/postgresql/)
