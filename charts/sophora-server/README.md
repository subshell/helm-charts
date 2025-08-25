# Sophora server

The required secrets must be present before you install the server.

## Archive repository persistence

Starting with Sophora 5, the archive repository is no longer available.
To disable all archive-related storage options, set `sophora.server.persistence.archiveType` to `none`.
In later chart versions this will be the default.

## Postgres connection

Starting with Sophora 5, the installation requires postgres. 
You can provide credentials via a secret: `sophora.server.persistence.postgres.secret`. 
To enable postgres support set `sophora.server.persistence.postgres.enabled` to `true`. 
For all other configuration options use `sophora.server.properties`. 

It's also possible to use postgres as your jcr repository. To use postgres with jcr set `sophora.server.persistence.repositoryType` to `postgres`.

## Multi Postgres support

Starting with Sophora 6, staging servers require postgres.
Typically, Sophora staging servers use statefulset scaling, but they still need a unique postgres database per instance. You can achieve this by doing the following:

* Set `sophora.server.persistence.multiPostgres.enabled` to `true`.
* Configure all postgres connections under `sophora.server.persistence.multiPostgres.byPodIndex`. Each config entry belongs to a pod at the index.

### Example

```yaml
sophora:
  server:
    persistence:
      multiPostgres:
        enabled: true
        byPodIndex:
        # config for pod 0
        - hostname: db.host
          port: "5432"
          database: "sophora-0"
          secret:
            name: secret-1
            usernameKey: username
            passwordKey: password
        # config for pod 1
        - hostname: db.host
          port: "5432"
          database: "sophora-1"
          secret:
            name: secret-1
            usernameKey: username
            passwordKey: password
```

See also: [Postgres Native Sidecar](#postgres-native-sidecar-k8s-129)

## Sophora RPC (Sophora v6+)
Sophora 6 introduces a completely new API for client-server communication called Sophora RPC (short srpc). Srpc is based on gRPC which in return is essentially HTTP/2 but requires specific non-default settings in most HTTP proxies, including Ingress Controllers.
To deal with this, the chart now supports deploying a second Ingress for the gRPC API, which can be configured differently from the main Ingress.

This is not enabled by default.
To enable it, set `grpcIngress.enabled` to `true` and configure it as needed.
The example configuration contains the required
settings for the Nginx Ingress Controller (all paths starting with `/sophora.srpc.` need to be forwarded as gRPC traffic).

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

#### Ingress with Ingress NGINX Controller

When using `ingress-nginx` you can set the following annotations. The `proxy-*-timeout` allows long running server requests like complex queries to run. The [default timeout of nginx](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) is 60 seconds which may not work for all cases and repository sizes. The `client-body-buffer-size` allows larger responses to be handled in memory.

```yaml
ingress:
  ingressClassName: "nginx"
  enabled: true
  annotations:
    nginx.ingress.kubernetes.io/client-body-buffer-size: 2m
    nginx.ingress.kubernetes.io/proxy-send-timeout: "300"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "300"
```

### Postgres native sidecar (k8s 1.29+)

**All Sophora cluster server since version 5 and all Sophora staging server since version 6 require a postgres database**

However, while the Sophora staging server supports replica scaling, each instance still requires a dedicated PostgreSQL database.
The simplest way to meet these requirements is by introducing native sidecar containers.
With this setup, each Sophora server now includes its own PostgreSQL instance.
Read more about native sidecar containers [here](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/).

Add a native sidecar container using the following configuration: 

```yaml
extraInitContainers:
  - name: "postgres"
    image: "postgres:17.5-alpine3.21"
    imagePullPolicy: "IfNotPresent"
    restartPolicy: Always
    ports:
      - name: http
        containerPort: 5432
        protocol: TCP
    env:
      - name: POSTGRES_USER
        value: postgres
      - name: POSTGRES_PASSWORD
        value: postgres
      - name: POSTGRES_DB
        value: sophora
    volumeMounts:
      - name: sophora-server-storage
        mountPath: /var/lib/postgresql/data
        subPath: postgres
    resources:
      requests:
        memory: 3G
      limits:
        memory: 3G
```

You may want to adjust configurations like `resources` or the postgres version. 
The volume mount `sophora-server-storage` is provided by default. You can safely use `postgres` as the subPath.
If you want to use your own volume, configure one in `extraVolumeClaimTemplates`. 

To complete the setup, add the following properties to `sophora.server.properties` to configure the postgres connection to the sidecar container.

```properties
# connection to postgres native sidecar container
sophora.persistence.postgres.database=sophora
sophora.persistence.postgres.username=postgres
sophora.persistence.postgres.password=postgres
sophora.persistence.postgres.hostname=localhost
sophora.persistence.postgres.port=5432
```

**Note**: For cluster servers we still recommend a separate postgres deployment, like Google Cloud SQL.

## Notable Changes

### 2.10.0

This version changes the configuration of the gRPC API since the latest pre-release versions of Sophora now run it on a separate port. The most notable change may be that
the configuration `grpcIngress.enabled` was removed in favor of `sophora.grpcApi.enabled`.

### 2.9.0

* The configuration `sophora.server.persistence.postgres.versionStoreEnabled` has been deprecated. Use `sophora.server.persistence.postgres.enabled` instead.
* New configuration `sophora.server.persistence.multiPostgres`. [Read more](#multi-postgres-support)

### 2.5.2
This version changes the paths for the gRPC-controller from the technology-driven name sophora.grpc to the product driven name sophora.srpc. This only affects server in version 6 or newer.

### 2.5.1
This version updates the pre-stop hook to version 2.1.0 which is required when using Sophora 6. It is still compatible with previous versions of Sophora.

### 2.5.0

This version of the Chart now supports deploying a second Ingress with the purpose to host the gRPC API, which is coming in Sophora 6.

### 2.1.0
Updates the pre-stop hook to version 2.0.0 and configures it accordingly.
Please note that this now involves the creation of another Role and RoleBinding for this specific use-case, so that
the hook can get information through the Kubernetes API. If you don't manage the Service Account through this Helm
chart, you may need to configure it manually to provide the required permissions.

### 2.0.0 (Breaking changes)
> [!WARNING]
> Please read this information carefully before updating!

* Renamed `serverModeLabeler.enabledOnClusterServers` to `serverModeLabeler.enabled`
* Removed `serverModeLabeler.createServiceAccount` in favour of `serviceAccount.create`
* Renamed `sidecars` to `extraContainers`
* Create `serviceAccount` by default even if `serverModeLabeler.enabled` is set to `false`
* Names of `Role` and `RoleBinding` have been suffixed with `-server-mode-labeler`. 
E.g. `cluster-01-sophora-server` -> `cluster-01-sophora-server-server-mode-labeler` 
