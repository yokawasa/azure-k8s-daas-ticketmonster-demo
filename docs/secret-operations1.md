# Secrets Operations in AKS Cluster

## Creating a Secret Using kubectl create secret
First of all, suppose you want to create a Secret to hold your password (**P@ssword123__**) for Postgres, store the password value in a file like this on your local machine: 
```
echo -n "P@ssword123__"  > dbpassword
```
The **kubectl create secret** command packages a file into a Secret and creates the object on the Apiserver. Here, you create a Secret named **dbsecret** from the file named **dbpassword** (the filename is used as keyname to retrieve the password from the Secret):

```
kubectl create secret generic dbsecret --from-file=./dbpassword
```

This is an example of a kubenetes YAML file where the password value, whose key name is **dbpassword**, in the Secret named **dbsecret** is used from environment variables:

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
            name: dbsecret
            key: dbpassword
```

## Check the Secret Using kubectl get secret
You can check the secret named **dbsecret** like this:
```
kubectl get secrets dbsecret -o yaml

(SAMPLE OUTPUT)
apiVersion: v1
data:
  dbpassword: UEBzc3dvcmQxMjNfXw==
kind: Secret
metadata:
  creationTimestamp: 2018-01-11T01:26:48Z
  name: dbsecret
  namespace: default
  resourceVersion: "121144"
  selfLink: /api/v1/namespaces/default/secrets/dbsecret
  uid: 7e471831-f66e-11e7-af99-0a58ac1f1902
type: Opaque
```

The value **UEBzc3dvcmQxMjNfXw==** that you get from the command above is actually base64 encoded value of the actual password. So, base64 decode it to get the password value:

```
echo -n "UEBzc3dvcmQxMjNfXw==" | base64 --decode
P@ssword123__
```

## Delete the Secret Using kubectl delete secret
You can delete the secret named **dbsecret** using kubectl delete secret:
```
kubectl delete secret dbsecret
```

## LINKS
- [Kubenetes Document - Configuration/Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)