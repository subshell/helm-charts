# planr-tools

This chart deploys the three `planr-tools` applications together:

* `newsroom-document-creator`
* `newsroom-feed`
* `newsroom-widget`

Each application is deployed as its own `Deployment`, `Service`, and `ConfigMap`, while the chart offers shared `Ingress` and `HTTPRoute` resources for path-based external access.

## Prerequisites

### Sophora credentials secret

A Kubernetes secret containing the Sophora CMS credentials is required. Create it before installing the chart:

```sh
kubectl create secret generic planr-tools-sophora-credentials \
  --from-literal=username=<your-username> \
  --from-literal=password=<your-password>
```

Expected keys:
- `username` — Sophora CMS username
- `password` — Sophora CMS password

### Ingress controller requirements

The `Ingress` resource uses `pathType: ImplementationSpecific` with nginx-style regex paths and a `rewrite-target` annotation to strip path prefixes before forwarding to each app. This requires an ingress controller that:

- Supports regex matching for `pathType: ImplementationSpecific`
- Supports `nginx.ingress.kubernetes.io/rewrite-target` with capture groups

The nginx ingress controller (`ingressClassName: nginx`) satisfies both requirements and is the default. Other controllers may not be compatible. Consider using `HTTPRoute` instead if you are not using nginx.

## Example values.yaml

```yaml
ingress:
  enabled: true
  ingressClassName: nginx
  hosts:
    - host: planr-tools.example.com

httpRoute:
  enabled: false

applications:
  documentCreator:
    service:
      type: ClusterIP
    config:
      sophora:
        client:
          server-connection:
            urls: https://cms.example.com
            username: ${SOPHORA_USERNAME}
            password: ${SOPHORA_PASSWORD}

  feed:
    service:
      type: ClusterIP
    config:
      sophora:
        client:
          server-connection:
            urls: https://cms.example.com
            username: ${SOPHORA_USERNAME}
            password: ${SOPHORA_PASSWORD}

  widget:
    service:
      type: ClusterIP
    config:
      sophora:
        client:
          server-connection:
            urls: https://cms.example.com
            username: ${SOPHORA_USERNAME}
            password: ${SOPHORA_PASSWORD}

commonEnv:
  - name: SOPHORA_USERNAME
    valueFrom:
      secretKeyRef:
        name: planr-tools-sophora-credentials
        key: username
  - name: SOPHORA_PASSWORD
    valueFrom:
      secretKeyRef:
        name: planr-tools-sophora-credentials
        key: password
```
