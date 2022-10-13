# External Secrets Helm Chart

A Helm chart for creating kubernetes secrets with the [External Secrets Operator](https://external-secrets.io/v0.4.4/). It is automatically deployed to the Unified Sophora GCS Helm Registry.

# Usage by example

```yaml
externalSecrets:
  - name: example
    store: gcpsm
    type: Opaque
    data:
      - key: my-secret-manager-key
        name: example-name
        version: latest
```

# External Secrets Operator API Versions

Since `0.2.0` we use `v1beta1` as the api version. 
This requires the External Secrets Operator in version [0.6.0](https://external-secrets.io/v0.6.0/guides/v1beta1/) or higher.