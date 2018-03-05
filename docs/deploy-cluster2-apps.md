# Deploy Cluster2 Applications

## 1.  Deploy Applications

Install the Apache HTTPD + modcluster by running the following commands:
```
kubectl create -f <repodir>/kubernetes/cluster2/modcluster.yaml --record
kubectl create -f <repodir>/kubernetes/cluster2/modcluster-service.yaml --record
```

Install the PostgreSQL server by running the following command:
```
kubectl create -f <repodir>/kubernetes/cluster2/postgres.yaml --record
kubectl create -f <repodir>/kubernetes/cluster2/postgres-service.yaml --record
```

Install the Wildfly Servers by running the following command ([NOTE] You don't need to create a Service for the Wildfly as it only act as a backend):
```
kubectl create -f <repodir>/kubernetes/cluster2/wildfly-server.yaml --record
```


Check all the deployments status:
```
kubectl get po,rs,svc,deploy -l context=AKSDemo

(SAMPLE OUTPUT)
NAME                            READY     STATUS    RESTARTS   AGE
po/modcluster-500718032-9xrsb   1/1       Running   0          1h
po/postgres-1898721337-d21mz    1/1       Running   0          1h
po/wildfly-1503803694-tmxd7     1/1       Running   0          1h

NAME                      DESIRED   CURRENT   READY     AGE
rs/modcluster-500718032   1         1         1         1h
rs/postgres-1898721337    1         1         1         1h
rs/wildfly-1503803694     1         1         1         1h

NAME             TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
svc/modcluster   LoadBalancer   10.0.159.141   13.92.228.153   80:30000/TCP   1h
svc/postgres     ClusterIP      10.0.13.178    <none>          5432/TCP       1h

NAME                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/modcluster   1         1         1            1           1h
deploy/postgres     1         1         1            1           1h
deploy/wildfly      1         1         1            1           1h
```
Take note of the EXTERNAL-IP for services/modcluster.

## 2. Access the applications

Check /mcm (mod_cluster manager):
```
open http://<modcluster external ip>/mcm
```

Access Ticket-Monster application:
```
open http://<modcluster external ip>/ticket-monster/
```
![](../images/ticket-monster-app.png)
