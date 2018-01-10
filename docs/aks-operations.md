#  AKS / k8s Cluster Operations



## Cleanup all k8s components
```
kubectl delete svc,deploy,ds -l context=AKSDemo
```



## Clean all resources in your resource group

MC_RG-aks_myK8sCluster_eastus
MC_<resource-group>_<aks-cluster>_<region>

