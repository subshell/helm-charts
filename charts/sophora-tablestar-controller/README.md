# Sophora TableStar Controller

This Helm Chart provides a general setup for Sophora **TableStar** Controller.

## Architecture

### TableStar Controller

* [deployment.yaml](templates/deployment.yaml) provides the actual spring application
  container
* [config.yaml](templates/config.yaml) helps mounting the spring application config files
  into to container