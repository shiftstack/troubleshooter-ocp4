# Logs and members

```
OpenShift Container Platform 3.11: etcd is located in kube-system project
OpenShift Container Platform 4.x: etcd is located in openshift-etcd project.
```

```
oc get pod -n openshift-etcd
oc logs etcd-XYZ-master-0 -c etcd -n openshift-etcd
oc rsh -n openshift-etcd <etcd pod>
(From inside container run below commands)
etcdctl member list -w table
etcdctl endpoint health --cluster
etcdctl endpoint status -w table
```

in case oc command doesn't work, connect with ssh to node and run

```
$ crictl logs $(crictl ps -aql --label  "io.kubernetes.container.name=etcd-member")
$ crictl logs  --since 48h $(crictl ps -aql --label  "io.kubernetes.container.name=etcd-member")
```

# number of objects in etcd

```
$ oc project openshift-etcd
$ oc get pods
[..]
$ oc rsh <POD_NAME>
[..]
sh-4.4# etcdctl get / --prefix --keys-only | sed '/^$/d' | cut -d/ -f3 | sort | uniq -c | sort -rn 
```

# number of secrets per namespace

```
oc get secrets -A --no-headers | awk '{ns[$1]++}END{for (i in ns) print i,ns[i]}'
```


# Events per component

```
awk '{print $1 " " $2}' cm-watch.log  | sort | uniq -c | sort -n --rev | head -n 10
```

# sources

[ETCD troubleshooting](https://access.redhat.com/articles/6271341)






oc get --raw /metrics | grep etcd_object_counts | grep events
oc --as system:admin -n openshift-kube-apiserver get -o json events | jq -r '.items[].metadata.creationTimestamp' | sort | head -n3
oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods


get / --prefix --keys-only | grep event | sort | uniq -c | sort -n --rev