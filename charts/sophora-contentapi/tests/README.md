# Sophora Content API Helm Chart Tests

This directory contains comprehensive unit tests for the sophora-contentapi Helm chart using [helm-unittest](https://github.com/helm-unittest/helm-unittest).

## Test Files

- **deployment_test.yaml** - Tests for the Deployment resource including:
  - Default values and overrides
  - Image configuration
  - Java options
  - Authentication secrets
  - Environment variables
  - Probes (startup, readiness, liveness)
  - Resource limits and requests
  - Pod annotations
  - Volume mounts

- **configmap_test.yaml** - Tests for the ConfigMap resource including:
  - Name overrides
  - Sophora configuration rendering
  - Required configuration validation
  - Complex configuration scenarios

- **service_test.yaml** - Tests for the Service resource including:
  - Default service configuration
  - Custom service types and ports
  - Service annotations
  - Selector labels

- **ingress_test.yaml** - Tests for the Ingress resource including:
  - Enabling/disabling ingress
  - IngressClassName configuration
  - Annotations
  - Single and multiple hosts
  - TLS configuration
  - Path types

- **httproute_test.yaml** - Tests for the HTTPRoute (Gateway API) resource including:
  - Enabling/disabling HTTPRoute
  - Parent gateway references
  - Hostnames configuration
  - Matches and filters
  - Annotations

- **extra-list_test.yaml** - Tests for extraDeploy resources including:
  - Rendering custom Kubernetes resources
  - Multiple resource types

## Running Tests

### Prerequisites

Install helm-unittest plugin:

```bash
helm plugin install https://github.com/helm-unittest/helm-unittest
```

### Run All Tests

From the chart root directory:

```bash
helm unittest .
```

### Run Specific Test File

```bash
helm unittest -f tests/deployment_test.yaml .
```

### Run with Verbose Output

```bash
helm unittest -v .
```

### Run with Colored Output

```bash
helm unittest --color .
```

## Test Coverage

The tests cover all properties defined in values.yaml:

- ✅ nameOverride / fullnameOverride
- ✅ image.repository / image.tag / image.pullPolicy
- ✅ imagePullSecrets
- ✅ javaOptions
- ✅ sophora.authentication.secret.*
- ✅ sophora.configuration.*
- ✅ startupProbe.*
- ✅ readinessProbe.*
- ✅ livenessProbe.*
- ✅ resources.*
- ✅ contentapi.extraEnv
- ✅ service.*
- ✅ ingress.*
- ✅ httpRoute.*
- ✅ extraDeploy
- ✅ podAnnotations

## Test Values Files

The `values/` directory contains test-specific values files used in tests:

- **service-custom.yaml** - Custom service configuration
- **configmap-complex.yaml** - Complex Sophora configuration
- **ingress-custom.yaml** - Custom ingress configuration
- **httproute-custom.yaml** - Custom HTTPRoute configuration
- **extradeploy-single.yaml** - Single extra resource
- **extradeploy-multiple.yaml** - Multiple extra resources

## Adding New Tests

When adding new properties to values.yaml:

1. Add test cases to the appropriate test file
2. Create new test value files if needed in `values/` directory
3. Update this README with the new test coverage
4. Run tests to ensure they pass

## Continuous Integration

These tests should be run as part of the CI/CD pipeline before releasing new chart versions.
