# Sophora UGC Proxy

This chart deploys Sophora UGC Proxy which is connected to several UGC instances. 

## What you need (requirements)

This chart requires the following already present in the target namespace:

* An ImagePullSecret for the subshell Docker Registry
* Secrets containing credentials to access UGC REST API and S3 Bucket of each UGC instance.