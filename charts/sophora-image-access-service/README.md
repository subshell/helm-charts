# Sophora Image Access Service

This Helm Chart provides a general setup for Sophora Image **Access** Service.

## Architecture

### Image Access Service

* [deployment.yaml](templates/deployment.yaml) provides the actual spring application
  container
* [service.yaml](templates/service.yaml) makes the deployment reachable from outside the
  pod
* [ingress.yaml](templates/ingress.yaml) makes the service reachable from outside the
  cluster
* [config.yaml](templates/config.yaml) helps mounting the spring application config files
  into to container

## Configuration notes

When configuring, be aware that Access- and Update Service *must* connect to the same S3 storage.