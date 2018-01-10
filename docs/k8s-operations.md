#  Kubernetes App Operations

## Scale the number of Pods:

Check the # of wildfly pod with **kubectl get po**:
```
kubectl get po

(SAMPLE OUTPUT)
NAME                         READY     STATUS    RESTARTS   AGE
modcluster-500718032-kfb17   1/1       Running   0          2h
omsagent-gj322               1/1       Running   0          16m
omsagent-hsc5r               1/1       Running   0          51m
wildfly-1364584080-2qswl     1/1       Running   0          1h
wildfly-1364584080-mpmgh     1/1       Running   0          1h
wildfly-1364584080-t5q9t     1/1       Running   0          1h
```

Or you can check with **kubectl get deploy**:
kubectl get deploy wildfly

(SAMPLE OUTPUT)
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
wildfly   3         3         3            3           1h


So you have 3 pods for wildfly. Then, if you want to scale the # of pods to 5, run the following command:
```
kubectl scale --replicas=5 deploy wildfly
```

Check the # of wildfly pod again:
```
kubectl get deploy wildfly

(SAMPLE OUTPUT)
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
wildfly   5         5         5            5           1h
```

## Update the kubernete app:

First of all, prepare a new container image for the app and push it to a container registry. 

### Option1: Update the app with **kubectl set image**: 

Suppose you upgrade the container image for the app from tag version 1.0 to 1.1, run the following command:

```
kubectl set image deploy wildfly wildfly=<acrLoginServer>/yoichikawasaki/wildfly-ticketmonster-ha:1.1 --record
```
### Option2: Update the app with **kubectl apply**: 

Suppose you upgrade the container image for the app from tag version 1.0 to 1.1, Replace the container image part of kubernetes/wildfly-server.yaml file with the container name:tag:

```
containers:
- name: wildfly
    image: yoichikawasaki/wildfly-ticketmonster-ha:1.1
```

Then, run the following command to update the app in your kubernete cluster:
```
kubectl apply -f <repodir>/kubernetes/wildfly-server.yaml --record
```

You can check if it's actually updated in the cluster with **kubectl describe** like this:
```
kubectl describe deploy wildfly

(SAMPLE OUTPUT)
...
   wildfly:
    Image:  yoichikawasaki/wildfly-ticketmonster-ha:1.1
...
```

## Cleanup all k8s components
```
kubectl delete svc,deploy,ds -l context=AKSDemo
```