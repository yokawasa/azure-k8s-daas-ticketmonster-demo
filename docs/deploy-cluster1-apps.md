# Deploy Cluster1 Applications

## 1.  Deploy Applications

Install the Apache HTTPD + modcluster by running the following commands:
```
kubectl create -f <repodir>/kubernetes/cluster1/modcluster.yaml --record
kubectl create -f <repodir>/kubernetes/cluster1/modcluster-service.yaml --record
```

Install the Wildfly Servers by running the following command ([NOTE] You don't need to create a Service for the Wildfly as it only act as a backend):
```
kubectl create -f <repodir>/kubernetes/cluster1/wildfly-server.yaml --record
```

Install the OMS daemonset by running the following command:
```
kubectl create -f <repodir>/kubernetes/cluster1/oms-daemonset.yaml --record
```


Check all the deployments status:
```
kubectl get po,rs,svc,deploy,ds -l context=AKSDemo

(SAMPLE OUTPUT)
NAME                            READY     STATUS    RESTARTS   AGE
po/modcluster-500718032-kfb17   1/1       Running   0          1h
po/omsagent-hsc5r               1/1       Running   0          57s
po/wildfly-1364584080-2qswl     1/1       Running   0          1h

NAME                      DESIRED   CURRENT   READY     AGE
rs/modcluster-500718032   1         1         1         1h
rs/wildfly-1364584080     1         1         1         1h

NAME             TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
svc/modcluster   LoadBalancer   10.0.13.220   13.92.171.134   80:30000/TCP   1h

NAME                DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/modcluster   1         1         1            1           1h
deploy/wildfly      1         1         1            1           1h

NAME          DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR                 AGE
ds/omsagent   1         1         1         1            1           beta.kubernetes.io/os=linux   58s
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
