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
