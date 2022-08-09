# Kubelet logs

```
oc adm node-logs --role master -u kubelet
oc adm node-logs --role worker -u kubelet

or

> oc debug node/<node> 

```
journalctl -b -f -u kubelet.service
```
