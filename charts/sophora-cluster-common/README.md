# Sophora Cluster Common

This Helm chart contains resources that are useful for a Sophora cloud-installation in general and are not tied to
one specific product.

The available resources in this chart are described in the following and are all optional and can be configured to one's
needs.

## Available Resources

### PodDistruptionBudget for Cluster Servers

This will install a PodDisruptionBudget for the Sophora Cluster Servers (primary and replicas) to prevent situations
where all servers are shut down simultaneously. The PDB for staging servers can be installed via the server Helm chart.

### "LoadBalancer" for Cluster Servers

This is not actually a load balancer but rather a service and ingress definition always pointing to the primary Sophora 
server. Typically, this is used to create a deterministic endpoint that can be entered by users to log in to Sophora.
To work out of the box, this requires that the *Server Mode Labeler* sidecar container of the servers is active (should be
by default).

### Alerts

This will install alerts that are not tied to one specific application but rather the general Sophora cluster state.
Look into the [alerting-runbook.md](./alerting-runbook.md) to see which alerts are available. Also check out the application's
charts to see if there are application specific alerts available.

## Parameters

### Common parameters

| Name               | Description                               | Value |
| ------------------ | ----------------------------------------- | ----- |
| `nameOverride`     | String to partially override the name     | `""`  |
| `fullnameOverride` | String to fully override the release name | `""`  |

### Cluster Server Loadbalancer

| Name                                                                      | Description                                               | Value               |
| ------------------------------------------------------------------------- | --------------------------------------------------------- | ------------------- |
| `clusterServerLb.enabled`                                                 | whether the service and ingress should be deployed or not | `false`             |
| `clusterServerLb.name`                                                    | names of the resources                                    | `cluster-server-lb` |
| `clusterServerLb.ingress.enabled`                                         | whether the ingress should be enabled                     | `true`              |
| `clusterServerLb.ingress.ingressClassName`                                | name of the ingressClass used for the ingress             | `""`                |
| `clusterServerLb.ingress.annotations`                                     | annotations for the ingress                               | `{}`                |
| `clusterServerLb.ingress.hosts`                                           | array with hostnames used for the ingress                 | `[]`                |
| `clusterServerLb.service.type`                                            | Kubernetes service type                                   | `ClusterIP`         |
| `clusterServerLb.service.selectorLabels.sophora.cloud/app`                | labels used to select the primary Sophora server          | `cluster-server`    |
| `clusterServerLb.service.selectorLabels.server.sophora.cloud/server-mode` | labels used to select the primary Sophora server          | `primary`           |
| `clusterServerLb.service.httpPort`                                        | the Sophora server's http port                            | `1196`              |
| `clusterServerLb.service.jmsPort`                                         | the Sophora server's jms port                             | `1197`              |
| `clusterServerLb.service.publishNotReadyAddresses`                        | whether the service should publish not ready addresses    | `true`              |

### Cluster Server Pod Disruption Budget

| Name                                                | Description                                | Value                    |
| --------------------------------------------------- | ------------------------------------------ | ------------------------ |
| `podDisruptionBudget.enabled`                       | whether the PDB should be installed or not | `false`                  |
| `podDisruptionBudget.name`                          | name of the PDB                            | `sophora-cluster-server` |
| `podDisruptionBudget.minAvailable`                  | minimum available replicas                 | `2`                      |
| `podDisruptionBudget.matchLabels.sophora.cloud/app` | selector label for the cluster servers     | `cluster-server`         |

### Alerting / Prometheus Rules

| Name                                  | Description                                   | Value   |
| ------------------------------------- | --------------------------------------------- | ------- |
| `prometheusRules.enabled`             | Whether the alerts should be installed        | `false` |
| `prometheusRules.defaultRulesEnabled` | Whether the default rules should be installed | `true`  |
| `prometheusRules.rules`               | allows to add custom rules                    | `[]`    |

### Extra Deploy

| Name          | Description                                                | Value |
| ------------- | ---------------------------------------------------------- | ----- |
| `extraDeploy` | Allows to specify custom resources that should be deployed | `[]`  |

