# Gateway Chart

This helm chart deploys a [Gateway](https://gateway-api.sigs.k8s.io/) resource to create load balancer infrastructure for ingress traffic. It can optionally retrieve certificates for the domains by using the cert-manager to retrieve Let's Encrypt certificates for TLS.

The design goal of this chart is that a single Gateway exists for the whole Kubernetes cluster. So it is expected to be deployed in its own namespace. The services to be made available with HTTPRoutes must reside in the namespace of the service and reference this gateway. So we have a distributed setup.

## What you need (requirements)

This chart requires the following already present. See the [GKE Gateway controller requirements](https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways#requirements) for Google Cloud requirements.

* The [Gateway API](https://gateway-api.sigs.k8s.io/) custom resource definitions (CRDs) must be installed at least version 'v1beta1'. For a GKE cluster enable "[Gateway API](https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways#enable-gateway)" by using channel "standard" (`CHANNEL_STANDARD` in [Terraform block `gateway_api_config`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_gateway_api_config)).

When using Google Kubernetes Engine (GKE):

* GKE version 1.24 or later.
* Your cluster must have the HttpLoadBalancing add-on enabled.
* If you are using the internal GatewayClasses, you must enable a proxy-only subnet for the proxy address.

Only when certificates should be provided by cert-manager with [annotated Gateway resource](https://cert-manager.io/docs/usage/gateway/):

* cert-manager setup with an [Issuer or ClusterIssuer](https://cert-manager.io/docs/configuration/).
* cert-manager must have Gateway API enabled. To do so add `enableGatewayAPI: true` to the controller config.yaml. Requires version >= 1.15.

## Notes

- When using a regional load balancer then the IP address must be regional too. When using a global load balancer use a global IP address.

## Example values.yaml

### Basic

```yaml
gateway:
  https:
  - host: simple.example.com
```

### Basic with cert-manager certificate

```yaml
gateway:
  https:
  - host: simple.example.com

certManager:
  clusterIssuer: acme-issuer
```

### Extended

```yaml
nameOverride: testgateway
fullnameOverride: ''

gateway:
  className: gke-l7-global-external-managed-mc
  annotations:
    example.com/template-value: This is a test
    example.com/some.more: 1234
  addresses:
  - type: NamedAddress
    value: chart-example-address
  - value: 1.2.3.4
  https:
  - host: simple.example.com
  - host: chart-example.local
    allowedRoutes:
      namespaces:
        from: Selector
        selector:
          matchLabels:
            example: use-gateway
      kinds:
      - group: gateway.example.com
        kind: ExampleRoute
    tls:
      mode: Passthrough
      certRef: chart-example-tls
  listeners:
  - name: other-port
    hostname: other.example.com
    port: 12345
    protocol: example.com/bar
    tls:
      mode: Terminate
      certificateRefs:
      - name: other-certificate
        namspace: secret-ns
        kind: SpecialSecret
        group: foo.example.com
  - name: http
    port: 80
    protocol: HTTP
  infrastructure:
    annotations:
      foo: bar
    labels:
      bar: foo
    parametersRef:
      group: settings.example.com
      kind: ExampleSettings
      name: example-settings

certManager:
  clusterIssuer: acme-issuer

```
