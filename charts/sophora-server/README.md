# Sophora server

The required secrets must be present before you install the server.

## Tips for productive installations

### Cluster servers

#### Cluster replication

To enable multiple cluster server in one statefulset set `clusterReplication.enabled` to `true`. To reach individual server instances 
also set `clusterReplication.ingresses`, and `clusterReplication.services`. The order has to match
the order of pods in the stateful set. Here is an example of a simple configuration with two replicas:

```yaml
clusterReplication:
  enabled: true
  ingressesDefaults: 
    enabled: true
  ingresses: 
    - hosts:
      - host: "my-server01.com"
      tls:
        - secretName: my-server01-tls
          hosts:
            - "my-server01.com"
    - hosts:
      - host: "my-server02.com"
      tls:
        - secretName: my-server01.com-tls
          hosts:
            - "my-server02.com"
  servicesDefaults:
    annotations:
      kubernetes.io/tls-acme: "true"
```

#### Pod Anti Affinity

To prevent multiple cluster servers to be scheduled on the same k8s node you can use the podAntiAffinity. Per default,
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
case of a node failure at least one cluster server remains running.

#### Taint tolerations

Kubernetes allows to select a node to schedule a pod based on different criteria. If one wants to make sure pod is only scheduled 
on a certain node, one shall set a node affinity. If the node shall be exclusive for this kind of pod, there is the possibility
to taint the node and provide the pods with a set of toleration to tolerate the taint. In sophora one may use this to provide a 
separate node pool for a certain type of sophora servers exclusively.
Further information on how taints work: [kubernetes.io/Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/#example-use-cases)

#### Server mode pod labels

Cluster servers run a sidecar container which continuously labels the pods with their server mode
to make it possible to create a service which always points to the current primary server.

For the sidecar to work the server requires a service account with the permission to `get` and `patch` pods
in the namespace the server runs in. SA, Role and Role Binding are created if not unchecked via
`serverModeLabeler.createServiceAccount: false`. 
You can provide your own Service Account via `serviceAccountName:` in the values.
