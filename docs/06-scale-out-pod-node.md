#  Scale out Pods and Nodes

## [Manual] Scale the number of Pods:

Check the # of wildfly pod by running **kubectl get po**:
```
kubectl get po

(SAMPLE OUTPUT)
NAME                         READY     STATUS    RESTARTS   AGE
modcluster-500718032-kfb17   1/1       Running   0          2h
omsagent-gj322               1/1       Running   0          16m
omsagent-hsc5r               1/1       Running   0          51m
wildfly-1364584080-2qswl     1/1       Running   0          1h
```

Or you can check by running **kubectl get deploy**:
```
kubectl get deploy wildfly

(SAMPLE OUTPUT)
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
wildfly   1         1         1            1           1h
```

So you have a pod for wildfly. Then, if you want to scale the # of pods to 3, run the following command:
```
kubectl scale --replicas=3 deploy wildfly
```

Check the # of wildfly pod again:
```
kubectl get deploy wildfly

(SAMPLE OUTPUT)
NAME      DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
wildfly   3         3         3            3           1h
```

## [Manual] Scale the number of Nodes:

Follow the steps in **Scale AKS Cluster Nodes** of [3.Manage AKS Cluster](03-manage-aks-cluster.md)


## [Autosale] Configure Horizontal Pods Autoscaling (HPA):

TBU (as I'm having some issues in HPA configuration)
- [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

