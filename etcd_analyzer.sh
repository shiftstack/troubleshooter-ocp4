#/bin/bash

ETCD0=$(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -1| cut -d ' ' -f1)
ETCD1=$(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -2|head -1| cut -d ' ' -f1)
ETCD2=$(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -3|head -1| cut -d ' ' -f1)

# oc exec $(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -1| cut -d ' ' -f1)  -c etcdctl -n openshift-etcd --  etcdctl watch / --prefix  --write-out=fields
# oc exec $(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -2|head -1| cut -d ' ' -f1)  -c etcdctl -n openshift-etcd --  etcdctl watch / --prefix  --write-out=fields
# oc exec $(oc --as system:admin -n openshift-etcd get -l k8s-app=etcd pods|tail -3|head -1| cut -d ' ' -f1)  -c etcdctl -n openshift-etcd --  etcdctl watch / --prefix  --write-out=fields


echo -e "[$ETCD0]"
oc exec $ETCD0 -c etcdctl -- etcdctl endpoint status -w table
echo -e ""
oc exec $ETCD0 -c etcd -- ip a s dev br-ex|grep inet
echo -e ""
echo -e "Found $(oc logs $ETCD0 -c etcd|grep overloaded|wc -l) overloaded messages"
echo -e "Found $(oc logs $ETCD0 -c etcd|grep 'took too long'|wc -l) took too long messages"
echo -e "Found $(oc logs $ETCD0 -c etcd|grep clock|wc -l) clock difference messages"
echo -e "COMPACTION: \n $(oc logs $ETCD0 -c etcd|grep compaction|tail -8|cut -d ':' -f10|cut -c 2-12)"
echo -e ""
echo -e "[$ETCD1]"
oc exec $ETCD1 -c etcdctl -- etcdctl endpoint status -w table
echo -e ""
oc exec $ETCD1 -c etcd -- ip a s dev br-ex|grep inet
echo -e ""
echo -e "Found $(oc logs $ETCD1 -c etcd|grep overloaded|wc -l) overloaded messages"
echo -e "Found $(oc logs $ETCD1 -c etcd|grep 'took too long'|wc -l) took too long messages"
echo -e "Found $(oc logs $ETCD1 -c etcd|grep clock|wc -l) clock difference messages"
echo -e "COMPACTION: \n $(oc logs $ETCD1 -c etcd|grep compaction|tail -8|cut -d ':' -f10|cut -c 2-12)"
echo -e ""
echo -e "[$ETCD2]"
oc exec $ETCD2 -c etcdctl -- etcdctl endpoint status -w table
echo -e ""
oc exec $ETCD2 -c etcd -- ip a s dev br-ex|grep inet
echo -e ""
echo -e "Found $(oc logs $ETCD2 -c etcd|grep overloaded|wc -l) overloaded messages"
echo -e "Found $(oc logs $ETCD2 -c etcd|grep 'took too long'|wc -l) took too long messages"
echo -e "Found $(oc logs $ETCD2 -c etcd|grep clock|wc -l) clock difference messages"
echo -e "COMPACTION: \n $(oc logs $ETCD2 -c etcd|grep compaction|tail -8|cut -d ':' -f10|cut -c 2-12)"
echo -e ""