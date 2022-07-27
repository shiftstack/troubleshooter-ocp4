# SSL

you can check with openssl if the private key matches the certificate:

```
openssl x509 -noout -modulus -in cert.crt | openssl md5
openssl rsa -noout -modulus -in privkey.txt | openssl md5
```


# apiserver bad cert

We can try to get master back to healthy.


Seems that kubelet is failing as per following evidence:

```
Jul 19 11:35:02 v0003594.example.com hyperkube[1713]: E0719 11:35:02.335495    1713 kubelet.go:2303] "Error getting node" err="node \"v0003594.example.com\" not found"
Jul 19 11:35:02 v0003594.example.com hyperkube[1713]: E0719 11:35:02.397515    1713 transport.go:112] "No valid client certificate is found but the server is not responsive. A restart may be necessary to retrieve new initial credentials." lastCertificateAvailabilityTime="2022-07-19 10:30:02.115098063 +0000 UTC m=+0.534789930" shutdownThreshold="5m0s"
Jul 19 11:35:02 v0003594.example.com hyperkube[1713]: E0719 11:35:02.436898    1713 kubelet.go:2303] "Error getting node" err="node \"v0003594.example.com\" not found"
Jul 19 11:35:02 v0003594.example.com hyperkube[1713]: I0719 11:35:02.501282    1713 csi_plugin.go:1031] Failed to contact API server when waiting for CSINode publishing: csinodes.storage.k8s.io "v0003594.example.com" is forbidden: User "system:anonymous" cannot get resource "csinodes" in API group "storage.k8s.io" at the cluster scope
There are no pending CSRs as it can not contact the API server, so we can renew the kubelet certs manually:
```

SSH access to affected node and stop the kubelet service with sudo user.

# systemctl stop kubelet

Backup all files inside /var/lib/kubelet/pki. After the certificates are backed up, delete all the files under /var/lib/kubelet/pki.

```
# cp /var/lib/kubelet/pki/* /tmp/backup_pki
# rm /var/lib/kubelet/pki/*
```

Start the kubelet service again.

```
# systemctl start kubelet
```

Check from the oc command if there is a new pending certificate. If there is, please approve it. If possible try to use the kubeconfig:

```
$ oc --kubeconfig=/path/to-your-system-admin.kubeconfig get csr -o name | xargs oc --kubeconfig=/path/to-your-system-admin.kubeconfig adm certificate approve
```

Check again from /var/lib/kubelet/pki, if the certificates are renewed.

If this is not enough we will take a look at this: https://access.redhat.com/solutions/4923031