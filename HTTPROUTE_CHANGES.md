# HTTPRoute Support Added to Helm Charts

## Summary

All Helm charts in the `helm-charts` repository that contain Kubernetes Ingress resources have been extended to also provide optional HTTPRoute resources for the Gateway API. Chart versions have been incremented to new minor versions to reflect these changes.

## Charts Updated

The following 18 charts now support HTTPRoute (Gateway API) in addition to Ingress:

1. **o-neko** - v2.0.1 → v2.1.0
2. **o-neko-catnip** - v1.3.4 → v1.4.0
3. **sophora-admin-dashboard** - v1.5.0 → v1.6.0
4. **sophora-ai** - v2.0.4 → v2.1.0
5. **sophora-contentapi** - v1.0.2 → v1.1.0
6. **sophora-image-access-service** - v1.4.0 → v1.5.0
7. **sophora-image-ai** - v2.1.3 → v2.2.0
8. **sophora-importer** - v2.4.1 → v2.5.0 (HTTPRoute support already existed, updated for consistency)
9. **sophora-indexing-service** - v1.5.0 → v1.6.0
10. **sophora-linkchecker** - v0.1.4 → v0.2.0
11. **sophora-media-finder** - v0.2.6 → v0.3.0
12. **sophora-metadata-supplier** - v1.3.6 → v1.4.0
13. **sophora-schema-docs** - v2.1.4 → v2.2.0
14. **sophora-seo-check** - v1.0.3 → v1.1.0
15. **sophora-server** - v3.1.2 → v3.2.0
16. **sophora-ugc** - v2.0.15 → v2.1.0
17. **sophora-webclient** - v1.4.5 → v1.5.0
18. **sophora-youtube-connector** - v1.2.4 → v1.3.0

## Implementation Details

### HTTPRoute Templates

Each chart now includes a `templates/httproute.yaml` file that:
- Is conditionally created based on `httpRoute.enabled` value
- Uses the Gateway API v1 specification
- Supports parentRefs for Gateway attachment
- Supports hostname filtering
- Supports path matching (PathPrefix, Exact, or RegularExpression)
- Includes the same labels and annotations pattern as Ingress resources
- Routes traffic to the same backend service as the Ingress

### Values.yaml Configuration

Each chart's `values.yaml` file now includes an `httpRoute` section with the following configuration options:

```yaml
httpRoute:
  enabled: false                # Whether to create HTTPRoute (disabled by default)
  parentRefs: []                # Gateway references
  hostnames: []                 # Hostnames for routing
  pathMatchType: PathPrefix     # Path match type (PathPrefix, Exact, RegularExpression)
  pathValue: /                  # Path value for matching
  annotations: {}               # Additional annotations
```

### Special Cases

1. **sophora-image-access-service**: Supports multiple HTTPRoutes via `extraHttpRoutes` array, similar to its `extraIngress` support.

2. **sophora-importer**: Already had HTTPRoute support with a more advanced configuration including custom rules and filters.

3. **sophora-server**: Supports additional HTTPRoute for gRPC service via `grpcHttproute`, similar to its `grpcIngress` support.

## Usage Example

To enable HTTPRoute for a chart deployment:

```yaml
httpRoute:
  enabled: true
  parentRefs:
    - name: my-gateway
      namespace: gateway-system
  hostnames:
    - "myapp.example.com"
  pathMatchType: PathPrefix
  pathValue: /
  annotations:
    custom.annotation: "value"
```

## Migration Path

Users can:
1. Continue using Ingress resources (default behavior)
2. Enable HTTPRoute alongside Ingress for testing
3. Migrate to HTTPRoute exclusively by disabling Ingress and enabling HTTPRoute

All changes are backward compatible - existing deployments will continue to work without modification.

## Gateway API Compatibility

The HTTPRoute resources use the `gateway.networking.k8s.io/v1` API version, which is the stable Gateway API specification.
