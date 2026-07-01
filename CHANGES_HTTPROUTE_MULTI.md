# Allow configuration of multiple HTTPRoute resources per chart

July 2026

## Summary

[PR #276](https://github.com/subshell/helm-charts/pull/276) updated multiple Helm charts to support configuring **multiple Gateway API `HTTPRoute` resources** via a new `httpRoutes` map, replacing the previous single `httpRoute` (and `extraHttpRoutes` where present). This is intended to allow defining multiple distinct routes per chart instance.

## Changes

 * Replace `httpRoute` / `extraHttpRoutes` values with a new `httpRoutes` map in chart values.
 * Update `templates/httproute.yaml` to render one `HTTPRoute` per entry in `httpRoutes`.
 * Update Helm unittest fixtures to validate multiple rendered `HTTPRoute` documents and update `artifacthub.io/changes` notes.

## How to update

The `httpRoute` field has been replaced by `httpRoutes`. Update your values as follows:

 * Rename `httpRoute` to `httpRoutes`
 * Remove the `enabled` field
 * Add a name key directly under `httpRoutes` (e.g. `primary`)
 * Move `parentRefs`, `hostnames`, and any other route fields one indentation level deeper, under that name key

Before:

```yaml
httpRoute:
  enabled: true
  parentRefs:
    [...]
  hostnames:
    [...]
```

After:

```yaml
httpRoutes:
  primary:
    parentRefs:
      [...]
    hostnames:
      [...]
```
