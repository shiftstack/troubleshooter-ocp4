#/bin/bash

STAMP="$(echo $stamp|tr _ ' '|xargs -0 date -d)"

ETCD0=$(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -1| cut -d ' ' -f1)
ETCD1=$(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -2|head -1| cut -d ' ' -f1)
ETCD2=$(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -3|head -1| cut -d ' ' -f1)

# oc exec $(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -1| cut -d ' ' -f1)  -c etcdctl -n openshift-etcd --  etcdctl watch / --prefix  --write-out=fields
# oc exec $(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -2|head -1| cut -d ' ' -f1)  -c etcdctl -n openshift-etcd --  etcdctl watch / --prefix  --write-out=fields
# oc exec $(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -3|head -1| cut -d ' ' -f1)  -c etcdctl -n openshift-etcd --  etcdctl watch / --prefix  --write-out=fields



echo -e ""
echo -e "-[$ETCD0]--------------------"

echo -e ""
oc exec $ETCD0 -c etcdctl -- etcdctl endpoint status -w table
echo -e "IPs:"
oc exec $ETCD0 -c etcd -- ip a s dev br-ex|grep inet
echo -e "Errors and dropped packets:"
oc exec $ETCD0 -c etcd -- ip -s link show dev br-ex
echo -e ""
echo -e "Latency against API is $(curl -k https://api.$(echo $ETCD0| sed 's/.*://').com -w "%{time_connect}\n"|tail -1)"
echo -e ""
echo -e "LOGS \nstart on $(oc logs $ETCD0 -c etcd|head -60|tail -1|cut -d ':' -f3|cut -c 2-14)"
echo -e "ends on $(oc logs $ETCD0 -c etcd|tail -1|cut -d ':' -f3|cut -c 2-14)"
echo -e ""
echo -e "Found $(oc logs $ETCD0 -c etcd|grep overloaded|wc -l) overloaded messages"
echo -e "Found $(oc logs $ETCD0 -c etcd|grep 'took too long'|wc -l) took too long messages"
echo -e "Found $(oc logs $ETCD0 -c etcd|grep clock|wc -l) clock difference messages"
echo -e "Found $(oc logs $ETCD0 -c etcd|grep heatbeat|wc -l) heartbeat messages"
echo -e ""
echo -e "COMPACTION: \n$(oc logs $ETCD0 -c etcd|grep compaction|tail -8|cut -d ':' -f10|cut -c 2-12)"
echo -e ""
echo -e "-[$ETCD1]--------------------"
echo -e ""
oc exec $ETCD1 -c etcdctl -- etcdctl endpoint status -w table
echo -e ""
echo -e "IPs:"
oc exec $ETCD1 -c etcd -- ip a s dev br-ex|grep inet
echo -e "Errors and dropped packets:"
oc exec $ETCD1 -c etcd -- ip -s link show dev br-ex
echo -e ""
echo -e "Latency against API is $(curl -k https://api.$(echo $ETCD1| sed 's/.*://').com -w "%{time_connect}\n"|tail -1)"
echo -e ""
echo -e "LOGS \nstart on $(oc logs $ETCD1 -c etcd|head -60|tail -1|cut -d ':' -f3|cut -c 2-14)"
echo -e "ends on $(oc logs $ETCD1 -c etcd|tail -1|cut -d ':' -f3|cut -c 2-14)"
echo -e ""
echo -e "Found $(oc logs $ETCD1 -c etcd|grep overloaded|wc -l) overloaded messages"
echo -e "Found $(oc logs $ETCD1 -c etcd|grep 'took too long'|wc -l) took too long messages"
echo -e "Found $(oc logs $ETCD1 -c etcd|grep clock|wc -l) clock difference messages"
echo -e "Found $(oc logs $ETCD1 -c etcd|grep heatbeat|wc -l) heartbeat messages"
echo -e ""
echo -e "COMPACTION: \n$(oc logs $ETCD1 -c etcd|grep compaction|tail -8|cut -d ':' -f10|cut -c 2-12)"
echo -e ""
echo -e "-[$ETCD2]--------------------"
echo -e ""
oc exec $ETCD2 -c etcdctl -- etcdctl endpoint status -w table
echo -e ""
echo -e "IPs:"
oc exec $ETCD2 -c etcd -- ip a s dev br-ex|grep inet
echo -e "Errors and dropped packets:"
oc exec $ETCD2 -c etcd -- ip -s link show dev br-ex
echo -e ""
echo -e "Latency against API is $(curl -k https://api.$(echo $ETCD2| sed 's/.*://').com -w "%{time_connect}\n"|tail -1)"
echo -e ""
echo -e "LOGS \nstart on $(oc logs $ETCD2 -c etcd|head -60|tail -1|cut -d ':' -f3|cut -c 2-14)"
echo -e "ends on $(oc logs $ETCD2 -c etcd|tail -1|cut -d ':' -f3|cut -c 2-14)"
echo -e ""
echo -e "Found $(oc logs $ETCD2 -c etcd|grep overloaded|wc -l) overloaded messages"
echo -e "Found $(oc logs $ETCD2 -c etcd|grep 'took too long'|wc -l) took too long messages"
echo -e "Found $(oc logs $ETCD2 -c etcd|grep clock|wc -l) clock difference messages"
echo -e "Found $(oc logs $ETCD2 -c etcd|grep heatbeat|wc -l) heartbeat messages"
echo -e ""
echo -e "COMPACTION: \n$(oc logs $ETCD2 -c etcd|grep compaction|tail -8|cut -d ':' -f10|cut -c 2-12)"
echo -e ""

echo -e ""
echo -e "[NUMBER OF OBJECTS IN ETCD]"
echo -e ""
oc exec $ETCD0 -c etcdctl -- etcdctl get / --prefix --keys-only | sed '/^$/d' | cut -d/ -f3 | sort | uniq -c | sort -rn|head -14
echo -e ""

echo -e "[BIGGEST CONSUMERS]"
echo -e ""
oc exec $ETCD0 -c etcdctl -n openshift-etcd -- etcdctl get / --prefix --keys-only > keysonly.txt
cat keysonly.txt | grep event |cut -d/ -f3,4| sort | uniq -c | sort -n --rev |head -10

# oc exec $ETCD0  -c etcdctl -n openshift-etcd --  etcdctl watch / --prefix  --write-out=fields > fields.txt













#   $ oc debug node/<master_node>
#   [...]
#   sh-4.4# chroot /host bash
#   podman run --privileged --volume /var/lib/etcd:/test quay.io/peterducai/openshift-etcd-suite:latest fio


    # $ oc debug node/<master_node>
    # [...]
    # sh-4.4# chroot /host bash
    # [root@<master_node> /]# podman run --volume /var/lib/etcd:/var/lib/etcd:Z quay.io/openshift-scale/etcd-perf