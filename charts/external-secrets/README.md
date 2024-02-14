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

- `name` of the Kubernetes secret to create.
- `data.key` is the identifier in the remote store which holds the secret value.
- `data.name` the secret key of the Kubernetes secret to receive the value.
