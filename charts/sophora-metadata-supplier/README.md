# Sophora Metadata Supplier

**Note**: The Sophora Metadata Supplier ist not horizontally scalable and runs as a single pod deployed in a Kubernetes cluster.

## Mappings

This Helm Chart supports the installation of additional mappings via s3 or container image (see `metadataSupplier.mapping`).

## Alerts

To enable prometheus alerts, set `prometheusRule.enabled: true` in your values.

The default rules include an alert which is triggered if the job queue of the Sophora Metadata Supplier is full over a period of time. It can be configured by setting the following values below `prometheusRule.defaultRules.jobQueue`:
* `maxQueueSize` (default: 1000)
* `maxQueueTime` (default: 10m)
* `maxQueueSeverity` (default: high)
To disable the default rules, set `prometheusRule.defaultRules.enabled: false`.

You can add custom alerts via `prometheusRule.rules`.