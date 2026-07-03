This library chart holds common templates to be used in many charts.

## Usage

To use this chart add it as dependency to your chart.

```yaml
dependencies:
  - name: common
    version: "0.1.0"
    repository: "oci://ghcr.io/subshell/helm-charts/common"
```

Afterwards you need to run `helm dependency build` to add the actual chart to your local chart.

You can use parts of this chart by using `include` or `template` and provide a scope.

```yaml
{{- include "common.httproutes" (list . (dict "labels" $labels)) }}
```

## Development

Keep in mind:

> In the context of the named template, `$` will refer to the scope you passed in and not some global scope.

See Helm documentation about [Library Charts](https://helm.sh/docs/topics/library_charts/) and [Named templates](https://helm.sh/docs/chart_template_guide/named_templates)
