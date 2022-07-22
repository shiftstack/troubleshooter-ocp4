


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


# sources

[ETCD troubleshooting](https://access.redhat.com/articles/6271341)