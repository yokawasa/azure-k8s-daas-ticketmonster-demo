# azure-k8s-daas-ticketmonster-demo
Ticket-Monster HA Cluster Demo using Azure Kubernetes Services (AKS) and Managed PostgreSQL

![](images/azure-k8s-daas-oms-ticketmonster-demo-arch.png)

This project is a fork of the [devops-demo](https://github.com/rafabene/devops-demo) by [rafabene](https://github.com/rafabene) that contains files that allows you to run [Ticket Monster](https://developers.redhat.com/ticket-monster/) on a [WildFly](http://www.wildfly.org/) server on [Azure Kubernates Services(AKS)](https://docs.microsoft.com/en-us/azure/aks/) + using [Azure Database for PostgreSQL](https://docs.microsoft.com/en-us/azure/postgresql/) and [OMS/LogAnalytic Service](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-containers) in Azure

The pieces of this demo are:

- Apache HTTPD + mod_cluster
    - POD
    - Services
- Wildfly 10.x Application Server + Ticket Monster application
    - POD
- Azure Database for Postgres 9.5 or 9.6
    - Managed PostgreSQL Service in Azure
- OMS + Log Analytics
    - Managed Monitor and Log Analytics Service in Azure

## Preparations
### Azure Database for Postgres

### OMS + Log Analytics

## Running the Kubernetes Cluster on AKS

## Operations + Troubleshooting

## LINKS
- [Ticket Monster](https://developers.redhat.com/ticket-monster/)
- [WildFly](http://www.wildfly.org/)
- [ModCluster](http://mod-cluster.jboss.org/)
- [Azure Kubernates Services(AKS)](https://docs.microsoft.com/en-us/azure/aks/)
- [Azure Database for PostgreSQL](https://docs.microsoft.com/en-us/azure/postgresql/)
- [OMS/LogAnalytic Service](https://docs.microsoft.com/en-us/azure/log-analytics/log-analytics-containers)
