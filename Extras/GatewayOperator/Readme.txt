Welcome to the Gateway operator.  
For information about this operator, please contact: curtisb@netapp.com
This operator is designed to provision SVM in an existing ONTAP cluster.

1. Install of the operator:
kubectl create -f gatewayoperator.yaml

2. Provide a required ONTAP cluster administrator credentials:

apiVersion: v1
kind: Secret
metadata:
  name: ontap-cluster1-admin
  namespace: gateway
type: kubernetes.io/basic-auth
stringData:
  username: admin
  password: Netapp1!

3. Provide an optional ONTAP SVM administrator (vsadmin) credentials:

apiVersion: v1
kind: Secret
metadata:
  name: ontap-svm0-admin
  namespace: gateway
type: kubernetes.io/basic-auth
stringData:
  username: vsadmin
  password: Netapp1!

4. Create / edit a custom resource (CR):

apiVersion: gateway.netapp.com/v1alpha1
kind: StorageVirtualMachine
metadata:
  name: svm0
  namespace: gateway
spec:
  svmName: svm0
  clusterHost: 192.168.0.101
  debug: false
  aggregates:
  - name: Cluster1_01_FC_1
  management:
    name: manage1
    ip: 192.168.0.30
    netmask: 255.255.255.0
    broadcastDomain: Default
    homeNode: Cluster1-01
  vsadminCredentials:
    name: ontap-svm0-admin
    namespace: gateway
  clusterCredentials:
    name: ontap-cluster1-admin
    namespace: gateway
  nfs:
    enabled: true
    v3: true
    v4: true
    v41: true
    interfaces:
    - name: nfs1
      ip: 192.168.0.31
      netmask: 255.255.255.0
      broadcastDomain: Default
      homeNode: Cluster1-01
    export:
      name: default
      rules:
      - clients: 0.0.0.0/0
        protocols: any
        rw: any
        ro: any
        superuser: any
        anon:  "65534"

