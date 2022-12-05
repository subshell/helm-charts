# Helm Chart: Auxi documentation

This chart deploys the documentation of Auxi.

It is a simple webserver serving the static HTML of the generated docs. The only relevant config is the one for the ingress, so you can reach the documentation from "outside" and the tag of the image.

## Example values.yaml

````yaml
image:
  tag: latest

service:
  port: 80
  targetPort: 80

ingress:
  annotations:
    cert-manager.io/cluster-issuer: "issuer value"
  hosts:
    - host: "docs.auxi.com"
  tls:
    - hosts:
        - "*.auxi.com"
      secretName: "myLittleSecret"
````