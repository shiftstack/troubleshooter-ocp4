Full list of commands to run the test:

~~~
# oc debug node/<node-name>

cp -r /var/run/secrets/kubernetes.io/serviceaccount/ /host/tmp/serviceaccounts 
chroot /host

mkdir -p /var/run/secrets/kubernetes.io/serviceaccount/
cp -r /tmp/serviceaccounts/* /var/run/secrets/kubernetes.io/serviceaccount/
cd /tmp/serviceaccounts/
ls -alh 

mv ..2022_06_17_05_26_13.454198819 /var/run/secrets/kubernetes.io/serviceaccount/ <--- that file name will be different
cd /var/run/secrets/kubernetes.io/serviceaccount/
ln -s ..2022_06_17_05_26_13.454198819 ..data.  <--- that file name will be different



export K8S_USER="system:serviceaccount:default:default" 
export NAMESPACE="default" 
export BINDING="defaultbinding" 
export ROLE="defaultrole" 

kubectl delete clusterrole $ROLE
kubectl create rolebinding $BINDING
kubectl delete clusterrolebinding root-cluster-admin-binding

kubectl create clusterrole $ROLE  --verb="*"  --resource="*.*"
kubectl create rolebinding $BINDING --clusterrole=$ROLE --user=$K8S_USER -n $NAMESPACE
kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --user=$K8S_USER


oc login --token=sha256~VDMVYHQmeHT12jwp7JhDnSQjG66Pnb7pTgzGFwPj6wg --server=https://api.ocp410.ocptest.ocp:6443 <--- get the token from the web console

oc project default 

cd /home/core

RELEASE_IMAGE=$(oc get clusterversion version -o=jsonpath='{.status.desired.image}') 
echo $RELEASE_IMAGE 
TEST_IMAGE=$(oc adm release info --image-for='tests' $RELEASE_IMAGE) 
echo $TEST_IMAGE


vi secret <--- get it from web console 
oc image extract $TEST_IMAGE --file="/usr/bin/openshift-tests" -a secret 
chmod +x openshift-tests 


Set the proxy and no_proxy variables


./openshift-tests run openshift/conformance/parallel -o out.log