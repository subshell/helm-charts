# Helm Chart: Sophora server

The required secrets must be present before you install the servers.

```shell
# First you need the sophora Helm repository:
helm repo add sophora https://docker.subshell.com/chartrepo/sophora --username=... --password=...

# Deploy the servers:
helm install --namespace sophora -f ./values.yaml my-sophora-server-release sophora/sophora-server
```

## Tips for productive installations

### Cluster servers

#### podAntiAffinity
To prevent multiple cluster servers to be scheduled on the same k8s node you can use the podAntiAffinity. Per default
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

This code will give all sophora servers deployed by this file the label `sophora.cloud/app=cluster-server` and then perform
a check during scheduling whether a deployment on a k8s node already has a pod running with these labels. If so, the scheduler
will use a different node to schedule the deployment.

You could also use a different `topologyKey` in order to make sure that deployments are not only spread across unique nodes but
also across unique zones or regions.

This is only neccessary for cluster servers as there are usually only two of them and you would want to ensure that in
case of a node failure at least one cluster server remains running.
