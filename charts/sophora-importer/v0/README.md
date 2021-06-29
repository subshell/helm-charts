# Helm Chart: Sophora Importer

## Dockerfile for additional importer data (libs, xsl files, ...)

Setting up a docker image with additional importer libraries and xsl files required by the Sophora importer.
The saxon licence can be part of the `data/libs` directory but preferably should be provided as a k8s secret.
Supported directories are:

* `data/libs`
* `data/xsl`
* (`data/misc` for additional content required by the transformations)

## S3

This version of the helm chart supports only the importer until version 3 without using S3.