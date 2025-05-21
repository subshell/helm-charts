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
- `data[0].key` is the identifier in the remote store which holds the secret value.
- `data[0].name` the secret key of the Kubernetes secret to receive the value.

# Changelog

- ! Change: Since chart version 2.0.0 requires external-secrets >= v0.16.0 (released April 2025) to use the `v1` apis instead of `v1beta1`.
