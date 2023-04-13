# Sophora Image Update Service

This Helm Chart provides a general setup for Sophora Image **Update** Service.

## Architecture

### Image Update Service

* [deployment.yaml](templates/deployment.yaml) provides the actual spring application
  container
* [config.yaml](templates/config.yaml) helps mounting the spring application config files
  into to container

## Configuration notes

When configuring, be aware that Access- and Update Service *must* connect to the same S3 storage.