# Sophora Helm Charts

This repo is a collection of Sophora [Helm charts](https://helm.sh/docs/topics/charts/).

## Required Helm plugins

    helm plugin install https://github.com/chartmuseum/helm-push

## Requirements for Helm Charts in this repo

Each Helm chart should follow these rules:

* **Readme**: How does the Helm chart work and what are the main components
* **Example**: At the bare minimum the readme should contain an exemplary `values.yaml` file.
* **values.yaml documentation**: The `values.yaml` file should be well documented.
* **Useful defaults**: Whenever possible the default `values.yaml` should provide useful defaults. 

## subshell Helm repository

The Helm Charts are published to [https://docker.subshell.com/](https://docker.subshell.com/). Most of the Helm charts
can be found under [the sophora helm repository](https://docker.subshell.com/harbor/projects/8/helm-charts).

To use the subshell sophora repo execute these commands (this is only required once):

    helm repo add sophora https://docker.subshell.com/chartrepo/sophora

Before you have a look at the following commands, you should select the kubernetes namespace you are currently 
working on:

    kubectl config set-context --current --namespace=<insert-namespace-name-here>

To **deploy** a Helm Chart manually:

    helm push <path-to-the-chart> sophora

To **install** a Helm Chart for the first time:

    helm install -f values.yaml <name-of-the-release> <name-of-the-chart>[:<version-of-the-chart>]

To **upgrade** the Helm Chart:

    helm upgrade -f values.yaml <name-of-the-release> <name-of-the-chart>[:<version-of-the-chart>]

To **uninstall** a Helm Chart:

    helm uninstall <name-of-the-release>

To grant k8s access to a docker repository:

    k get secret dockersubshell --namespace=default -oyaml | sed s/"namespace: default"/"namespace: webclienthelmtest"/\ | k apply --namespace=webclienthelmtest -f -
    kubectl -n webclienthelmtest patch serviceaccount default -p '{"imagePullSecrets": [{"name": "dockersubshell"}]}'

*Note*: The <name-of-the-release> is commonly the project name and optionally an additional identifier.
For example: *ndr-sophora-webclient*.

## misc

### Tools

To view your helm deployments we recommond to install [k9s](https://github.com/derailed/k9s).

### Useful commands

Creating a k8s secret inline:

     create secret generic sophora-user-credentials --from-literal=username="admin" --from-literal=password="admin"