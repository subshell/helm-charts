# O-Neko Catnip

Helm Chart for [O-Neko Catnip](https://github.com/subshell/o-neko-catnip).

## Requirements

To install O-Neko Catnip with this chart you will need to create a secret manually which contains admin user
credentials for O-Neko in fields named `username` and `password`. This secret needs to be referenced in the
`values.yaml` file.

## Parameters

### Common parameters

| Name                 | Description                               | Value |
| -------------------- | ----------------------------------------- | ----- |
| `nameOverride`       | String to partially override the name     | `""`  |
| `fullnameOverride`   | String to fully override the release name | `""`  |
| `imagePullSecrets`   | Docker registry secret names as an array  | `[]`  |
| `hostAliases`        | Host aliases available to the application | `nil` |
| `resources.limits`   | The resource limits for the container     | `{}`  |
| `resources.requests` | The resource requests for the container   | `{}`  |


### O-Neko Catnip parameters

| Name                          | Description                                                           | Value                        |
| ----------------------------- | --------------------------------------------------------------------- | ---------------------------- |
| `oneko.image.name`            | O-Neko Catnip image repository                                        | `subshellgmbh/o-neko-catnip` |
| `oneko.image.tag`             | O-Neko Catnip image tag                                               | `1.1.0`                      |
| `oneko.image.imagePullPolicy` | Image Pull Policy                                                     | `IfNotPresent`               |
| `oneko.api.baseUrl`           | The base URL of the O-Neko installation, e.g. my.oneko.com            | `nil`                        |
| `oneko.api.auth.secretName`   | The name of the secret which contains the O-Neko credentials          | `nil`                        |
| `oneko.catnipUrl`             | The base URL of the O-Neko Catnip installation, e.g. catnip.oneko.com | `nil`                        |


### Probes

| Name                                 | Description                              | Value |
| ------------------------------------ | ---------------------------------------- | ----- |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe       | `10`  |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe   | `0`   |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe         | `1`   |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe          | `2`   |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe     | `3`   |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe | `0`   |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe       | `5`   |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe        | `1`   |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe      | `3`   |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe  | `0`   |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe        | `5`   |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe         | `10`  |


### Traffic Exposure parameters

| Name                             | Description                                          | Value   |
| -------------------------------- | ---------------------------------------------------- | ------- |
| `service.annotations`            | annotations for the service                          | `{}`    |
| `service.type`                   | Kubernetes service type                              | `nil`   |
| `service.sessionAffinity`        | the service's sessionAffinity                        | `None`  |
| `service.sessionAffinityConfig`  | additional sessionAffinity configuration             | `{}`    |
| `service.loadBalancerIP`         | A loadBalancerIP configuration                       | `nil`   |
| `service.clusterIP`              | The service's clusterIP                              | `nil`   |
| `ingress.ingressClassName`       | name of the ingressClass used for the ingress        | `nil`   |
| `ingress.hosts`                  | Array with hostnames used for the ingress            | `nil`   |
| `ingress.tls`                    | TLS configuration of the ingress as an array         | `nil`   |
| `ingress.annotations`            | annotations for the ingress                          | `{}`    |
| `ingress.defaultBackend.enabled` | Whether the default backend should be enabled or not | `false` |


### Metrics and Alerting

| Name                                 | Description                                                 | Value   |
| ------------------------------------ | ----------------------------------------------------------- | ------- |
| `serviceMonitor.enabled`             | Whether the serviceMonitor resource should be deployed      | `false` |
| `serviceMonitor.interval`            | Prometheus scrape interval                                  | `10s`   |
| `prometheusRule.enabled`             | Whether the prometheusRule resource should be deployed      | `false` |
| `prometheusRule.defaultRulesEnabled` | Whether the default alerting rules should be enabled or not | `true`  |
| `prometheusRule.rules`               | Custom alerting rules which can be deployed                 | `[]`    |

