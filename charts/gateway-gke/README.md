# Gateway for GKE

This chart deploys a Gateway resource to create a Google Layer 7 HTTP(S) Load Balancer. It also can retrieve certificates for the domains by using the cert-manager to retrieve Let's Encrypt certificates.

The design goal of this chart is that a single Gateway exists for the whole Kubernetes cluster. So it is expected to be deployed in a separate namespace. The services to be made available with HTTPRoutes must reside in the namespace of the service. So we have a distributed setup.

Currently only internal gateway is supported.

## What you need (requirements)

This chart requires the following already present. See the [GKE Gateway controller requirements](https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways#requirements) too.

* GKE version 1.24 or later.
* The [Gateway API](https://gateway-api.sigs.k8s.io/) custom resource definitios (CRDs) must be installed at least v1beta1. For a GKE cluster enable "[Gateway API](https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways#enable-gateway)" by using channel "standard" (`CHANNEL_STANDARD` in [Terraform block `gateway_api_config`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_gateway_api_config)).
* Your cluster must have the HttpLoadBalancing add-on enabled.
* If you are using the internal GatewayClasses, you must enable a proxy-only subnet.

Only for certificates provided by cert-manager:

* cert-manager setup with an ClusterIssuer.

## Example values.yaml

```yaml
TODO
```
