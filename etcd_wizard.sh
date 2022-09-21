



ETCD_POD=$(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -1| cut -d ' ' -f1)