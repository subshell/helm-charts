# opentelemetry-instrumentation

This chart contains the resource `Instrumentation` that is used as a configuration source for OpenTelemetry (OTEL) automatic instrumentation
and only works in conjunction with an OTEL Operator.  
The helm chart of the OTEL Operator needs to be installed separately on the same kubernetes cluster, which also installs required CRDs for this chart.

The `Instrumentation` object provided by this chart is intended to enable instrumentation and export of traces only. 
Logs and metrics exports are disabled.

## References

| Name                         | Link                                                                                                            |
|------------------------------|-----------------------------------------------------------------------------------------------------------------|
| OTEL Operator for Kubernetes | https://opentelemetry.io/docs/platforms/kubernetes/operator                                                     |
| OTEL Operator Helm Chart     | https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-operator             |
| Instrumentation CRD          | https://github.com/open-telemetry/opentelemetry-operator/blob/main/docs/api/instrumentations.md#instrumentation |
