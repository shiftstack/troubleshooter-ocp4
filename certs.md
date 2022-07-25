# SSL

you can check with openssl if the private key matches the certificate:

```
openssl x509 -noout -modulus -in cert.crt | openssl md5
openssl rsa -noout -modulus -in privkey.txt | openssl md5
```