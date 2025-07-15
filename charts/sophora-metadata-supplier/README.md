# Sophora Metadata Supplier

**Note**: The Sophora Metadata Supplier ist not horizontally scalable and runs as a single pod deployed in a Kubernetes cluster.

## Mappings

This Helm Chart supports the installation of additional mappings via s3 or container image (see `metadataSupplier.mapping`).

## Alerts

To enable a prometheus alert when the job queue is full for some time set `prometheusRule.enabled: true` in your values. You can add custom alerts via `prometheusRule.rules`.

To disable the default rules, set `prometheusRule.defaultRules.enabled: false`.