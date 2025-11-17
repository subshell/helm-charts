# Sophora Metadata Supplier

**Note**: The Sophora Metadata Supplier ist not horizontally scalable and runs as a single pod deployed in a Kubernetes cluster.

## Mappings

This Helm Chart supports the installation of additional mappings via s3 or container image (see `metadataSupplier.mapping`).

## Alerts

To enable prometheus alerts, set `prometheusRule.enabled: true` in your values.

The default rules include an alert which is triggered if the job queue of the Sophora Metadata Supplier is full over a period of time. It can be configured by setting the following values below `prometheusRule.defaultRules.jobQueue`:

- `maxQueueSize` (default: 1000)
- `maxQueueTime` (default: 10m)
- `maxQueueSeverity` (default: high)
  To disable the default rules, set `prometheusRule.defaultRules.enabled: false`.

You can add custom alerts via `prometheusRule.rules`.

### Extra Deploy

Sometimes you may want to deploy extra objects alongside your importer, such as a Secret containing basicAuth configuration for your ingress.
To cover these cases, the chart allows adding the full kubernetes resource specification of other objects using the extraDeploy parameter.
Creating a Secret for the ingress with basic auth case is shown in this example.

```yaml
extraDeploy:
  - |
    apiVersion: v1
    data:
      auth: Zm9vOiRhcHIxJE9GRzNYeWJwJGNrTDBGSERBa29YWUlsSDkuY3lzVDAK
    kind: Secret
    metadata:
      name: basic-auth
      namespace: default
    type: Opaque
```
