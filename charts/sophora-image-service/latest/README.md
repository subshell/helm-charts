# Helm Chart: Sophora Image Service
This Helm Chart provides a general setup for Sophora Image **Access** Service and Sophora Image **Update** Service.  

## Architecture
### Image Access Service
* [access-service-deployment.yaml](./templates/access-service-deployment.yaml) provides the actual spring application container
* [access-service-service.yaml](./templates/access-service-service.yaml) makes the deployment reachable from outside the pod
* [access-service-ingress.yaml](./templates/access-service-ingress.yaml) makes the service reachable from outside the cluster
* [access-service-config.yaml](./templates/access-service-config.yaml) helps mounting the spring application config files into to container
### Image Update Service
* [update-service-deployment.yaml](./templates/update-service-deployment.yaml) provides the actual spring application container
* [update-service-config.yaml](./templates/update-service-config.yaml) helps mounting the spring application config files into to container

## Configuration notes
Because Access- and Update Service *must* connect to the same S3 storage, the storage can only be configured at 
one place.  