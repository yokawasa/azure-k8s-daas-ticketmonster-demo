# Create Secret for PostgreSQL

Creating a Secret Manually
```
echo -n "ticketmonster-docker" | base64

dGlja2V0bW9uc3Rlci1kb2NrZXI=
```

vi postgres-secret.yaml
```
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
type: Opaque
data:
  userPassword: dGlja2V0bW9uc3Rlci1kb2NrZXI=
```

Create secret with kubectl
```
kubectl create -f postgres-secret.yaml
```

Check created secret
```
$ kubectl get secrets postgres-secret -o yaml

apiVersion: v1
data:
  userPassword: dGlja2V0bW9uc3Rlci1kb2NrZXI=
kind: Secret
metadata:
  creationTimestamp: 2018-04-02T13:26:48Z
  name: postgres-secret
  namespace: default
  resourceVersion: "4096054"
  selfLink: /api/v1/namespaces/default/secrets/postgres-secret
  uid: 7f46b00c-3679-11e8-b2f6-0a58ac1f0597
type: Opaque
```
See the password by base64 decoding the string
```
echo "dGlja2V0bW9uc3Rlci1kb2NrZXI=" |base64 --decode
-> ticketmonster-docker
```
