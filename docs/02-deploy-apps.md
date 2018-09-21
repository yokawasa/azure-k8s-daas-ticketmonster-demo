# 02 - Deploy Applications to Kubernete Cluster

## 0. Clone the Github repo and change directory to the repo top
```
git clone https://github.com/yokawasa/azure-k8s-daas-ticketmonster-demo.git
cd azure-k8s-daas-ticketmonster-demo
```

## 1.  Deploy Applications

Install the PostgreSQL server by running the following command:
```
kubectl create -f kubernetes/postgres-secret.yaml --record
kubectl create -f kubernetes/postgres.yaml --record
kubectl create -f kubernetes/postgres-service.yaml --record
```

Then, install the Apache HTTPD + modcluster by running the following commands:
```
kubectl create -f kubernetes/modcluster.yaml --record
kubectl create -f kubernetes/modcluster-service.yaml --record
```

Finally, install the Wildfly servers by running the following command ([NOTE] You don't need to create a Service for the Wildfly as the mod-cluster acts as a balancer for the Wildfly servers):
```
kubectl create -f kubernetes/wildfly-server-1.yaml --record
```

Check all the deployed objects status including Pods(`po|pods`), ReplicaSets(`rs|replicasets`), Services(`svc|services`), Deployments(`deploy|deployments`):
```
kubectl get po,rs,svc,deploy -l context=AKSDemo
```
Sample Output:
```
NAME                             READY     STATUS    RESTARTS   AGE
po/modcluster-79644db9c8-64jpf   1/1       Running   0          2h
po/postgres-7c95f9bdf7-flnbp     1/1       Running   0          2h
po/wildfly-7df855b4c8-pdthc      1/1       Running   0          1h

NAME                       DESIRED   CURRENT   READY     AGE
rs/modcluster-79644db9c8   1         1         1         2h
rs/postgres-7c95f9bdf7     1         1         1         2h
rs/wildfly-7df855b4c8      1         1         1         1h

NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
svc/modcluster   ClusterIP   10.0.228.173   <none>        80/TCP     2h
svc/postgres     ClusterIP   10.0.235.89    <none>        5432/TCP   2h

NAME                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/modcluster   1         1         1            1           2h
deploy/postgres     1         1         1            1           2h
deploy/wildfly      1         1         1            1           1h
```


## 2. Install Nginx Ingress Controller

Browse to the auto-created AKS resource group named `MC_<ResourceGroup>_<ClusterName>_<region>` and select the DNS zone. Take note of the DNS zone name. This name is needed in next strep.

![](../images/ingress-dns-name.png)

Then, open the following file and replace `<CLUSTER_SPECIFIC_DNS_ZONE>` with the DNS zone that you obtained

```
vi kubernetes/ingress-controller.yaml

---
spec:
  rules:
  - host: ticketapp.<CLUSTER_SPECIFIC_DNS_ZONE>
    http:
      paths:
      - backend:
          serviceName: modcluster
          servicePort: 80
        path: /ticket-monster
```

Finally, install the nginx ingress controller by running the following command:
```
kubectl create -f kubernetes/ingress-controller.yaml --record
```

You can validate that the ingress controller was installed
```
$ kubectl get ingress

(Sample output)
NAME         HOSTS                                                ADDRESS        PORTS     AGE
httprouter   ticketapp.f7418ec8af894af8a2ab.eastus.aksapp.io   138.91.112.166    80        2m
```

You can browse to the public IP assigned for the ingress controller.
```
kubectl get svc -n kube-system | grep nginx

(Sample output)
addon-http-application-routing-nginx-ingress          LoadBalancer   10.0.48.208    138.91.112.166   80:31935/TCP,443:30405/TCP   3h
```
The nginx controller will use a LoadBalancer type service where the backend is of type ClusterIP

## 3. Access the applications

Access Ticket-Monster application:
```
open http://ticketapp.<CLUSTER_SPECIFIC_DNS_ZONE>/ticket-monster/
```
![](../images/ticket-monster-app.png)

---
[Top](../README.md) | [Back](01-create-aks-cluster.md) | [Next](03-manage-aks-cluster.md)
