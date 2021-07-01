# Sophora Helm Charts

This repo is a collection of Sophora [Helm charts](https://helm.sh/docs/topics/charts/).
We require Kubernetes version **1.19+**.

## Required Helm plugins

    helm plugin install https://github.com/chartmuseum/helm-push

## Requirements for Helm Charts in this repo

Each Helm chart should follow these rules:

- **Readme**: How does the Helm chart work and what are the main components
- **Example**: At the bare minimum the readme should contain an exemplary `values.yaml` file.
- **values.yaml documentation**: The `values.yaml` file should be well documented.
- **Useful defaults**: Whenever possible the default `values.yaml` should provide useful defaults.
- **test-values.yaml**: A test `values.yaml` file which will be used by Jenkins to check the Chart file.

## subshell Helm repository

The Helm Charts are published to [https://docker.subshell.com/](https://docker.subshell.com/). Most of the Helm charts
can be found in [the sophora helm repository](https://docker.subshell.com/harbor/projects/8/helm-charts). They are published
by the [build](http://jenkins.subshell.com:9090/view/Weasel/view/All/job/helm-charts) and the [release](http://jenkins.subshell.com:9090/view/Weasel/view/All/job/release-helm-chart) Jenkins jobs.

To use the subshell sophora repo execute these commands (this is only required once):

    helm repo add sophora https://docker.subshell.com/chartrepo/sophora --username docker --password <see 1password>

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

    k get secret docker-subshell --namespace=default -oyaml | sed s/"namespace: default"/"namespace: webclienthelmtest"/\ | k apply --namespace=webclienthelmtest -f -
    kubectl -n webclienthelmtest patch serviceaccount default -p '{"imagePullSecrets": [{"name": "dockersubshell"}]}'

_Note_: The <name-of-the-release> is commonly the project name and optionally an additional identifier.
For example: _ndr-sophora-webclient_.

## using the Python build scripts

This repo uses a Python 3 command line script to build and release helm chart. You can easily use it locally, but first you have to install the dependencies:

    python3 -m pip install -r requirements.txt

`run.py` is the entrypoint to the command line script. Run `python3 run.py --help` to get more info. For example, you might want to test a specific chart or all charts with:

    python3 run.py sophora-server test
    python3 run.py all test

## Major versions

This repo does not use any version-branches but major releases are still possible. Older chart versions are stored in `v0/`,
`v1/`, ... subdirectories. They are created automatically by the release Jenkins job!

## misc

### Tools

To view your helm deployments we recommend:

- [k9s](https://github.com/derailed/k9s).
- [Lens](https://k8slens.dev/)

