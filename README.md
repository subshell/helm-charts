# helm-charts

Public helm charts supported by subshell.

## Add Repo

The following command allows you to download and install all the charts from this repository:

```sh
helm repo add subshell-public https://subshell.github.io/helm-charts
```

## Development

All charts should be located in the `charts` directory. On every push to the
main branch, a release of the helm chart is triggered automatically if the
`Chart.yaml` file contains a new version.

This git repository uses [Github Pages](https://helm.sh/docs/topics/chart_repository/#github-pages-example) to host the helm repository.
