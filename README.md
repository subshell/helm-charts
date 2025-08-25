# subshell Helm Charts

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/subshell)](https://artifacthub.io/packages/search?repo=subshell)

Helm charts supported by subshell.

## Add Repo

The following command allows you to download and install all the charts from this repository:

```sh
helm repo add subshell https://subshell.github.io/helm-charts
```

## Development

All charts should be located in the `charts` directory. On every push to the
main branch, a release of the helm chart is triggered automatically if the
`Chart.yaml` file contains a new version.

This git repository uses [Github Pages](https://helm.sh/docs/topics/chart_repository/#github-pages-example) to host the helm repository.

## Changelogs

Add a [Changelog](https://artifacthub.io/docs/topics/annotations/helm/#supported-annotations) for the new chart version. Example:

version: 1.2.3
annotations:
  artifacthub.io/changes: | 
    - kind: changed
      description: We now include a changelog in each helm chart.
      links:
        - name: GitHub Issue
          url: https://github.com/subshell/helm-charts/pull/171


* * *

Take a look at this project from the [subshell](https://subshell.com) team. We make [Sophora](https://subshell.com/sophora/): a content management software for content creation, curation, and distribution. [Join our team!](https://subshell.com/jobs/) | [Imprint](https://subshell.com/about/imprint/)

