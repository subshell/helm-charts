# Helm Chart: Repo Importer

TODO

## Cluster Server

The required secrets must be present before you install the servers.
```shell
# First you need the sophora Helm repository:
helm repo add sophora https://docker.subshell.com/chartrepo/sophora --username=... --password=...

# Deploy the servers:
helm install --namespace sophora -f ./cluster01.yaml cluster-01 sophora/sophora-server
helm install --namespace sophora -f ./cluster02.yaml cluster-02 sophora/sophora-server
```


## Staging Server
