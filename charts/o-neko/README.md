# O-Neko

O-Neko lets everyone preview and try out new features of your software by creating on-demand test environments for feature branches. O-Neko is Kubernetes-native and allows for flexible project configurations via Helm charts. Make sure developers, testers, project managers, product owners and clients are on the same page! Preview and test before you merge!

[O-Neko on GitHub](https://github.com/subshell/o-neko)

## TL;DR

```
$ helm repo add subshell-public https://subshell.github.io/helm-charts
$ helm install my-release subshell-public/o-neko
```

## Introduction

This chart installs O-Neko in Kubernetes using Helm.

## Requirements

For O-Neko to work properly you will need a running MongoDB instance.

To install O-Neko using this Helm chart you will need to create three secrets using your favorite method of doing it:

A secret containing the MongoDB credentials, e.g.:

```
kubectl create secret generic mongodb-credentials --from-literal=mongodb-password="SECRET" --from-literal=mongodb-root-password="SECRET" --from-literal=mongodb-replica-set-key="SECRET"
```

A "credentialsCoderKey" secret used for symmetrical encryption of sensitive data in the database, e.g.:

```
kubectl create secret generic o-neko-credentials-coder-key --from-literal=key="SECRET"
```

A secret containing the MongoDB URI (incl. the MongoDB password), e.g.:

```
kubectl create secret generic oneko-mongodb-uri --from-literal=uri="mongodb://o-neko:SECRET@o-neko-db-mongodb-0.mongodb-headless:27017,o-neko-db-mongodb-1.mongodb-headless:27017,o-neko-db-mongodb-2.mongodb-headless:27017/o-neko?"
```

## Parameters

### Common parameters

| Name                 | Description                                           | Value                                                                                                           |
| -------------------- | ----------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `nameOverride`       | String to partially override the name                 | `""`                                                                                                            |
| `fullnameOverride`   | String to fully override the release name             | `""`                                                                                                            |
| `imagePullSecrets`   | Docker registry secret names as an array              | `[]`                                                                                                            |
| `javaOptions`        | String with Java VM Options passed to the application | `-XX:InitialRAMPercentage=50.0 -XX:MaxRAMPercentage=80.0 -XX:+CrashOnOutOfMemoryError -XX:+PerfDisableSharedMem` |
| `hostAliases`        | Host aliases available to the application             | `nil`                                                                                                           |
| `resources.limits`   | The resource limits for the container                 | `{}`                                                                                                            |
| `resources.requests` | The resource requests for the container               | `{}`                                                                                                            |

### O-Neko parameters

| Name                                        | Description                                                           | Value                    |
| ------------------------------------------- | --------------------------------------------------------------------- | ------------------------ |
| `oneko.image.name`                          | O-Neko image repository                                               | `subshellgmbh/o-neko`    |
| `oneko.image.tag`                           | O-Neko image tag                                                      | `1.8.0`                  |
| `oneko.image.imagePullPolicy`               | Image Pull Policy                                                     | `IfNotPresent`           |
| `oneko.env`                                 | array of environment variables passed to the container                |                          |
| `oneko.env[0].name`                         | default environment variable name for activation json logging         | `SPRING_PROFILES_ACTIVE` |
| `oneko.env[0].value`                        | name of the Spring profile used to activate json logging              | `json-logs`              |
| `oneko.helm.gcs.secret.name`                | The secret name of the Google Service Account used, if using Helm GCS | `nil`                    |
| `oneko.helm.gcs.secret.serviceAccountField` | The field in the secret of the Google Service Account                 | `nil`                    |
| `oneko.mongodb.secret.name`                 | Name of the secret holding the MongoDB connection URI                 | `nil`                    |
| `oneko.mongodb.secret.uriField`             | Name of the field in the secret containing the MongoDB URI            | `uri`                    |
| `oneko.credentialsCoderKeySecret.name`      | Name of the secret                                                    | `nil`                    |
| `oneko.credentialsCoderKeySecret.fieldName` | Name of the field in the secret                                       | `key`                    |
| `oneko.config`                              | The application.yaml containing the O-Neko application configuration  |                          |

### Probes

| Name                                 | Description                              | Value |
| ------------------------------------ | ---------------------------------------- | ----- |
| `startupProbe.failureThreshold`      | Failure threshold for startupProbe       | `10`  |
| `startupProbe.initialDelaySeconds`   | Initial delay seconds for startupProbe   | `10`  |
| `startupProbe.timeoutSeconds`        | Timeout seconds for startupProbe         | `1`   |
| `startupProbe.periodSeconds`         | Period seconds for startupProbe          | `2`   |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe     | `3`   |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe | `5`   |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe       | `5`   |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe        | `5`   |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe      | `3`   |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe  | `15`  |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe        | `10`  |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe         | `60`  |

### Traffic Exposure parameters

| Name                            | Description                                   | Value  |
| ------------------------------- | --------------------------------------------- | ------ |
| `service.annotations`           | annotations for the service                   | `{}`   |
| `service.type`                  | Kubernetes service type                       | `nil`  |
| `service.sessionAffinity`       | the service's sessionAffinity                 | `None` |
| `service.sessionAffinityConfig` | additional sessionAffinity configuration      | `{}`   |
| `service.loadBalancerIP`        | A loadBalancerIP configuration                | `nil`  |
| `service.clusterIP`             | The service's clusterIP                       | `nil`  |
| `ingress.ingressClassName`      | name of the ingressClass used for the ingress | `nil`  |
| `ingress.hosts`                 | Array with hostnames used for the ingress     | `nil`  |
| `ingress.tls`                   | TLS configuration of the ingress as an array  | `nil`  |
| `ingress.annotations`           | annotations for the ingress                   | `{}`   |

### Metrics

| Name                      | Description                                                         | Value                  |
| ------------------------- | ------------------------------------------------------------------- | ---------------------- |
| `serviceMonitor.enabled`  | Whether the serviceMonitor resource should be deployed              | `false`                |
| `serviceMonitor.interval` | Prometheus scrape interval                                          | `10s`                  |
| `serviceMonitor.path`     | HTTP path prometheus should use to scrape the application's metrics | `/actuator/prometheus` |
