# 02 - Deploy Applications to Kubernete Cluster

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

You can get only services status like this below (`-w` option is very useful to watch for changes after listing/getting the requested object):
```
kubectl get svc -l context=AKSDemo -w
```
Sample Output:
```
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
modcluster   LoadBalancer   10.0.159.141   13.92.228.153   80:30000/TCP   1h
postgres     ClusterIP      10.0.13.178    <none>          5432/TCP       1h
```
Take note of the EXTERNAL-IP for modcluster service (13.92.228.153 is the one in this example).

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
