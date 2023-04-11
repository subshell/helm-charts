# Sophora Importer for Sophora 3

## Dockerfile for additional importer data (libs, xsl files, ...)

Setting up a docker image with additional importer libraries and xsl files required by the Sophora importer.
The saxon licence can be part of the `data/libs` directory but preferably should be provided as a k8s secret.
Supported directories are:

* `data/libs`
* `data/xsl`
* (`data/misc` for additional content required by the transformations)

## S3

This version of the helm chart supports only the importer until version 3 without using S3.

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
