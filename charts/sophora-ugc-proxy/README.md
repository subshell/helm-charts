# Sophora UGC Proxy

This chart deploys the Sophora UGC Proxy, which acts as a gateway and is connected to several UGC instances (multi-tenant setup).

## What you need (requirements)

This chart requires the following already present in the target namespace:

* An `ImagePullSecret` for the subshell Docker Registry.
* Kubernetes `Secrets` containing the S3 bucket credentials (Access Key and Secret Key) for **each** configured tenant.

## Network configuration

This chart supports both traditional `Ingress` and the modern Gateway API via `HTTPRoute`.
It can be used to route incoming user-generated content submissions to the correct underlying UGC instances.

Always ensure that access to sensitive actuator or management endpoints is properly protected or internal-only. Adjust your ingress/route and network configurations accordingly.

## Example values.yaml

Below is a comprehensive example of how to configure the UGC Proxy for multiple tenants. Notice how the S3 credentials map the dynamically generated environment variables (e.g., `${SUBMISSIONS_S3_ACCESSKEYID_TENANT1}`) to the physical Kubernetes secrets defined under `authentication.secrets`.

```yaml
replicaCount: 1

image:
  repository: [docker.subshell.com/ugc/ugc-proxy](https://docker.subshell.com/ugc/ugc-proxy)
  pullPolicy: Always
  tag: "latest"

service:
  type: ClusterIP
  port: 80

# Configure Ingress OR HTTPRoute based on your cluster setup
ingress:
  enabled: false
  ingressClassName: nginx
  hosts:
    - host: "ugc-proxy.example.com"
      path: /
      pathType: Prefix

httpRoute:
  enabled: true
  parentRefs:
    - name: main-gateway
      namespace: gateway-system
  hostnames:
    - "ugc-proxy.example.com"

# Define the physical Kubernetes secrets that hold the S3 credentials
authentication:
  s3buckets:
    - tenantName: "tenant1"
      secretName: s3bucket-secret-1
      accessKeyKey: s3bucket-access-key-1
      secretIdKey: s3bucket-secret-id-1
    - tenantName: "tenant2"
      secretName: s3bucket-secret-2
      accessKeyKey: s3bucket-access-key-2
      secretIdKey: s3bucket-secret-id-2  
    # ... add as many S3 buckets as you need

sophora:
  configuration:
    management:
      endpoints.web.exposure.include: info, health
      endpoint:
        prometheus:
          enabled: true
        health:
          show-details: always
          show-components: always
      metrics:
        tags:
          application: ${spring.application.name}
      server:
        port: 8081

    spring:
      application:
        name: UGC Proxy
      profiles:
        active: prod

    # Basic authentication credentials to secure ugc proxy endpoints
    auth:
      username: "proxy-user"
      password: "proxy-password"

    # Multi-tenant routing and S3 configuration
    ugc-proxy:
      tenants:
        tenant1:
          s3:
            access-key-id: "${SUBMISSIONS_S3_ACCESSKEYID_TENANT1}"
            secret-access-key: "${SUBMISSIONS_S3_SECRETACCESSKEY_TENANT1}"
            host: "[https://storage.googleapis.com](https://storage.googleapis.com)"
            bucket-name: "tenant1-ugc-submissions"
          ugc-url: "ugc1.subshell.com"
          
        tenant2:
          s3:
            access-key-id: "${SUBMISSIONS_S3_ACCESSKEYID_TENANT2}"
            secret-access-key: "${SUBMISSIONS_S3_SECRETACCESSKEY_TENANT2}"
            host: "[https://storage.googleapis.com](https://storage.googleapis.com)"
            bucket-name: "tenant2-ugc-submissions"
          ugc-url: "ugc2.subshell.com"
          
          # ... add as many tenants as you need


resources:
  requests:
    cpu: "200m"
    memory: "2.5G"
  limits:
    memory: "2.5G"