# HTTPRoute Support Added to Helm Charts

## Summary

All Helm charts in the `helm-charts` repository that contain Kubernetes Ingress resources have been extended to also provide optional HTTPRoute resources for the Gateway API.

## Charts Updated

The following 18 charts now support HTTPRoute (Gateway API) in addition to Ingress:

1. **o-neko** - Added httproute.yaml template and values
2. **o-neko-catnip** - Added httproute.yaml template and values
3. **sophora-admin-dashboard** - Added httproute.yaml template and values
4. **sophora-ai** - Added httproute.yaml template and values
5. **sophora-contentapi** - Added httproute.yaml template and values
6. **sophora-image-access-service** - Added httproute.yaml template and values (with support for multiple routes)
7. **sophora-image-ai** - Added httproute.yaml template and values
8. **sophora-importer** - HTTPRoute support already existed (no changes needed)
9. **sophora-indexing-service** - Added httproute.yaml template and values
10. **sophora-linkchecker** - Added httproute.yaml template and values
11. **sophora-media-finder** - Added httproute.yaml template and values
12. **sophora-metadata-supplier** - Added httproute.yaml template and values
13. **sophora-schema-docs** - Added httproute.yaml template and values
14. **sophora-seo-check** - Added httproute.yaml template and values
15. **sophora-server** - Added httproute.yaml template and values
16. **sophora-ugc** - Added httproute.yaml template and values
17. **sophora-webclient** - Added httproute.yaml template and values
18. **sophora-youtube-connector** - Added httproute.yaml template and values

## Implementation Details

### HTTPRoute Templates

Each chart now includes a `templates/httproute.yaml` file that:
- Is conditionally created based on `httproute.enabled` value
- Uses the Gateway API v1 specification
- Supports parentRefs for Gateway attachment
- Supports hostname filtering
- Supports path matching (PathPrefix, Exact, or RegularExpression)
- Includes the same labels and annotations pattern as Ingress resources
- Routes traffic to the same backend service as the Ingress

### Values.yaml Configuration

Each chart's `values.yaml` file now includes an `httproute` section with the following configuration options:

```yaml
httproute:
  enabled: false                # Whether to create HTTPRoute (disabled by default)
  parentRefs: []                # Gateway references
  hostnames: []                 # Hostnames for routing
  pathMatchType: PathPrefix     # Path match type (PathPrefix, Exact, RegularExpression)
  pathValue: /                  # Path value for matching
  annotations: {}               # Additional annotations
```

### Special Cases

1. **sophora-image-access-service**: Supports multiple HTTPRoutes via `extraHTTPRoute` array, similar to its `extraIngress` support.

2. **sophora-importer**: Already had HTTPRoute support with a more advanced configuration including custom rules and filters.

3. **sophora-server**: Uses the server's HTTP port from `sophora.server.ports.http` configuration.

## Usage Example

To enable HTTPRoute for a chart deployment:

```yaml
httproute:
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
