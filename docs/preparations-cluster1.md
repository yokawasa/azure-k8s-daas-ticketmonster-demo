# Cluster1 Preparations
## 1. Azure Database for Postgres
1-1. Create an Azure Database for PostgreSQL server by following this guide - Create an Azure Database for PostgreSQL using [the Azure CLI](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-azure-cli) or [the Azure portal](https://docs.microsoft.com/en-us/azure/postgresql/quickstart-create-server-database-portal)

1-2. Disable "Enforce SSL connection" as Azure Database for PostgreSQL enable enforcement of SSL connections by default. You can configure this either by the Azure Portal or the Azure CLI. Here is the Azure CLI command for this configuration:

```
az postgres server update -g <myresourcegroup> -n <myaccountname> --ssl-enforcement Disabled
```
For more detail on this step, please refer to [Configure Enforcement of SSL](https://docs.microsoft.com/en-us/azure/postgresql/concepts-ssl-connection-security#configure-enforcement-of-ssl).

1-3. Add firewall rule to whitelist the IP range for connectivity by following this guide - Configure a server-level firewall rule using [the Azure CLI](https://docs.microsoft.com/en-us/azure/postgresql/tutorial-design-database-using-azure-cli#configure-a-server-level-firewall-rule) or [the Azure Portal](https://docs.microsoft.com/en-us/azure/postgresql/tutorial-design-database-using-azure-portal#configure-a-server-level-firewall-rule). 

For testing, simply open all IP addresses like this (NOT recommended for production senario):
```
az postgres server firewall-rule create -g <myresourcegroup> -s <myaccountname> --name AllowFullRangeIP --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255
```
For production, open only the AKS cluster's outbound IP! The outbound traffic should NAT via the external IP address of the load balancer associated with the AKS cluster. So find the external IP of the cluster and configure the firewall rule of the database after all cluster deployments are done.
```
$ kubectl get svc
NAME         TYPE           CLUSTER-IP   EXTERNAL-IP     PORT(S)        AGE
kubernetes   ClusterIP      10.0.0.1     <none>          443/TCP        4h
modcluster   LoadBalancer   10.0.13.220   13.92.171.134   80:30000/TCP  4h
```
In this example, 13.92.171.134 is an IP that you want to configure in the database firewall rule as the cluster's outbound IP:
```
az postgres server firewall-rule create -g <myresourcegroup> -s <myaccountname> --name AllowAKSClusterIP --start-ip-address 13.92.171.134 --end-ip-address 13.92.171.134
```

1-4. Once you have your account and database in Azure Database for Postgres, create a database named **ticketmonster**:
```
create database ticketmonster;
```

1-5. Finally, replace the environment variables part of kubernetes/wildfly-server.yaml file with your accounts info:
```
containers:
- name: wildfly
    image: yoichikawasaki/wildfly-ticketmonster-ha:1.0
    env:
    - name: POSTGRES_HOST
        value: <myaccount>.postgres.database.azure.com
    - name: POSTGRES_PORT
        value: "5432"
    - name: POSTGRES_USER
        value: <myuser>@<myaccount> # Server admin login name of Azure DB for PostgreSQL
    - name: POSTGRES_PASSWORD
        valueFrom:
          secretKeyRef:
            name: <mysecret>
            key: <key-for-password>
```
For **POSTGRES_PASSWORD** env value above, you need to create a secret to store your password for Postgres (sensitive data). Please follow [Secrets Operations](docs/secret-operations.md) to create a secret and add secret name (mysecret) and key (key-for-password) above.
- [Secrets Operations](docs/secret-operations.md).

**TODO**
- use [Open Service Broker for Azure](https://docs.microsoft.com/en-us/azure/aks/integrate-azure) to connect Azure Database for Postgres

## 2. OMS + Log Analytics

2-1. Create a new OMS workspace and get a workspace ID and primary key for it by following this guide - [Configure the monitoring solution](https://docs.microsoft.com/en-us/azure/aks/tutorial-kubernetes-monitor#configure-the-monitoring-solution).

2-2. Once you have the workspace ID and primary key of your OMS workspace, replace the values for WSID and KEY with your values in oms-daemonset.yaml.
```
containers:
- name: omsagent
    image: "microsoft/oms"
    imagePullPolicy: Always
    env:
    - name: WSID
        value: <WSID>
    - name: KEY
        value: <KEY>
```
After all AKS cluster setup are completed, OMS starts collect metrics and logs from the cluster. Here are the OMS container solution dashboard screen capture:

![](../images/azure-oms-container-solution.png)

## 3. Container images for a Ticket-Monster App
You can basically use a default container image ([yoichikawasaki/wildfly-ticketmonster-ha:1.0](https://hub.docker.com/r/yoichikawasaki/wildfly-ticketmonster-ha/)) for the Ticket-Monster app. However if you want to use your custom app, create a container image and push it to a container registry. Once you have a container image registered in the registry, replace the container image part of kubernetes/wildfly-server.yaml file with your container image:tag name.

```
containers:
- name: wildfly
    image: yoichikawasaki/wildfly-ticketmonster-ha:1.0
```