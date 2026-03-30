# planr-tools

This chart deploys the three `planr-tools` applications together:

* `newsroom-document-creator`
* `newsroom-feed`
* `newsroom-widget`

Each application is deployed as its own `Deployment`, `Service`, and `ConfigMap`, while the chart offers shared `Ingress` and `HTTPRoute` resources for path-based external access.

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
