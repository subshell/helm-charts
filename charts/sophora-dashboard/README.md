# Sophora Dashboard

This chart deploys the Sophora Dashboard with an ingress for external access.

## Example values.yaml

```yaml
image:
  tag: "4.0.0"

storageClassName: "ssd"

sophora:
  serverHostname: "cluster-01-sophora-server"
  authentication:
    serverSecret:
      name: "sophora-user-importer-credentials"
    solrSecret:
      name: "sophora-server-solr-credentials"
    jolokiaSecrets:
      server:
        name: "server-jolokia-credentials"
      importer:
        name: "importer-jolokia-credentials"
      indexer:
        name: "indexer-jolokia-credentials"

ingress:
  enabled: false

resources:
  requests:
    memory: "0.6G"
    cpu: "0.1"
  limits:
    memory: "1.25G"

```
