# External Secrets

A Helm chart for creating kubernetes secrets with the [External Secrets Operator](https://external-secrets.io/).

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
