# Sophora server

The required secrets must be present before you install the server.

## Archive repository persistence

Starting with Sophora 5 the archive repository is no longer available.
To disable all archive related storage options, set `sophora.server.persistence.archiveType` to `none`.
In later chart versions this will be the default.

## Postgres connection

Starting with Sophora 5, the installation requires postgres. 
You can provide credentials via a secret: `sophora.server.persistence.postgres.secret`. 
To enable the postgres version store set `sophora.server.persistence.postgres.versionStoreEnabled` to `true`. 
For all other configuration options use `sophora.server.properties`. 

It's also possible to use postgres as your jcr repository. To use postgres with jcr set `sophora.server.persistence.repositoryType` to `postgres`.

## Tips for productive installations

### Cluster servers

Cluster servers require one statefulset per instance. Deploy multiple statefulsets to create an actual sophora cluster. 
Therefore `replicaCount` only supports `0` and `1`.

#### Pod Anti-Affinity

To prevent multiple cluster servers from being scheduled on the same k8s node, you can use the podAntiAffinity. Per default,
you can write the following in your values file:

```yaml
additionalSelectorLabels:
  sophora.cloud/app: cluster-server

affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: sophora.cloud/app
              operator: In
              values:
                - cluster-server
          topologyKey: "kubernetes.io/hostname"
```

This configuration will give all sophora servers deployed by this file the label `sophora.cloud/app=cluster-server` and then perform
a check during scheduling whether a deployment on a k8s node already has a pod running with these labels. If so, the scheduler
will use a different node to schedule the deployment.

You could also use a different `topologyKey` in order to make sure that deployments are not only spread across unique nodes but
also across unique zones or regions.

This is only necessary for cluster servers as there are usually only two of them, and you would want to ensure that in
case of a node failure, at least one cluster server remains running.

#### Taint tolerations

Kubernetes allows selecting a node to schedule a pod based on different criteria. If one wants to make sure pod is only scheduled 
on a certain node, one shall set a node affinity. If the node shall be exclusive for this kind of pod, there is the possibility
to taint the node and provide the pods with a set of toleration to tolerate the taint. In Sophora, one may use this to provide a 
separate node pool for a certain type of sophora servers exclusively.
Further information on how taints work: [kubernetes.io/Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/#example-use-cases)

#### Server pre-stop lifecycle hook

All Sophora cluster servers are equipped with a pre-stop lifecycle hook, that is executed when the pod is about to shut down
due to user request, uninstallation or the Kubernetes scheduler deciding to move it to another node (etc.).

If the server to be shut down is the primary server, the hook will initiate a cluster switch to one of the other available
servers, if there are any. Before switching, it filters the list of available replicas to find those suitable to switch to.

The behaviour of the hook can be manipulated using the following **optional** annotations on the server's Pods:

1. `prestop.server.sophora.cloud/switch-enabled: "<true|false>"`
2. `prestop.server.sophora.cloud/is-switch-target: "<true|false>"`

The first annotation controls whether the server shutting down should switch. 
In some edge-cases, it might be useful to shut down a server without switching.

The second annotation can be used to specify whether the annotated server should be a valid switch target server. 
If set to `false`, the tool will not switch to that server.

Both annotations default to `true`, if not specified or the value is not parseable to a boolean value, because generally
switches should happen and should only be deactivated for maintenance, recovery or similar scenarios.

For this to work, the server's pod requires a service account with the permission to `get` and `list` Pods and services
in the namespace the server runs in. The SA, Role and Role Binding are created automatically.
The creation of these resources can be controlled with the `serviceAccount:` section in the values file.

#### Server mode pod labels

Cluster servers run a sidecar container which continuously labels the pods with their server mode
to make it possible to create a service which always points to the current primary server.

For the sidecar to work, the server requires a service account with the permission to `get` and `patch` Pods
in the namespace the server runs in. The SA, Role and Role Binding are created automatically by this chart.
The creation of these resources can be controlled with the `serviceAccount:` section in the values file.


## Notable Changes

## 2.1.0
Updates the pre-stop hook to version 2.0.0 and configures it accordingly.
Please note that this now involves the creation of another Role and RoleBinding for this specific use-case, so that
the hook can get information through the Kubernetes API. If you don't manage the Service Account through this Helm
chart, you may need to configure it manually to provide the required permissions.

## 2.0.0 (Breaking changes)
> [!WARNING]
> Please read this information carefully before updating!

* Renamed `serverModeLabeler.enabledOnClusterServers` to `serverModeLabeler.enabled`
* Removed `serverModeLabeler.createServiceAccount` in favour of `serviceAccount.create`
* Renamed `sidecars` to `extraContainers`
* Create `serviceAccount` by default even if `serverModeLabeler.enabled` is set to `false
* Names of `Role` and `RoleBinding` have been suffixed with `-server-mode-labeler`. 
E.g. `cluster-01-sophora-server` -> `cluster-01-sophora-server-server-mode-labeler` 
