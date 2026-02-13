# Use Artifacthub changes annotation as changelog

| <!-- -->  | <!-- -->                                                    |
|-----------|-------------------------------------------------------------|
| status    | accepted                                                    | 
| date      | ?                                                           |
| deciders  | subshell Team Koala                                         |
| consulted | ?                                                           |
| informed  | subshell developers                                         |
| <!-- -->  | <!-- -->                                                    |

## Context and Problem Statement

On Artifacthub our Helm charts get a nice website. To have a nice changelog it is possible to create it by an annotation.

## Decision Outcome

We use the annotation `artifacthub.io/changes` in all our Chart.yaml files to document the changes of the current version.

It contains a string with YAML. We prefer the structured form where the `kind` is given. Possible kinds:

- added
- changed
- deprecated
- removed
- fixed
- security

## Example

```yaml
name: example
version: 1.1.0
annotations:
  artifacthub.io/changes: |
    - kind: added
      description: "Added HTTPRoute support for Gateway API"
```

This describes the changes that are contained in the version `1.1.0` only.

## More Information

- https://blog.artifacthub.io/blog/changelogs/
- https://artifacthub.io/docs/topics/annotations/helm/#supported-annotations
