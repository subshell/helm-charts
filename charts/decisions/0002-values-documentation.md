# Documenting values with comments in YAML

| <!-- -->  | <!-- -->                                                    |
|-----------|-------------------------------------------------------------|
| status    | proposed                                                    | 
| date      | 2026-02-13                                                  |
| deciders  | Daniel Raap (subshell)                                      |
| consulted | -                                                           |
| informed  | -                                                           |
| <!-- -->  | <!-- -->                                                    |

## Context and Problem Statement

The purpose and format of a property in the charts values.yaml must be communicated to the chart user. Just the key in the values is often not enough to describe its purpose and usage.

## Considered Options

* Write an extensive ReadMe file that desribes all aspects of the values.yaml.
* Add comments directly inside the values.yaml file.

## Decision Outcome

Chosen option: "Add comments directly" in most cases. When detailed explanation is needed a paragraph in a ReadMe.md can be added.

We follow the [documentation recommendation by Helm](https://helm.sh/docs/chart_best_practices/values/#document-valuesyaml) to start each comment with the property name.

> Every defined property in `values.yaml` should be documented. The documentation string should begin with the name of the property that it describes, and then give at least a one-sentence description.

> Beginning each comment with the name of the parameter it documents makes it easy to grep out documentation, and will enable documentation tools to reliably correlate doc strings with the parameters they describe.

### Pros and Cons of Comments

Pro:
- It is easy to write a comment directly beside the YAML structure.
- A comment directly explains the YAML key and value.
- can be processed by tools parsing the values.yaml file.

Cons:
- The documentation is only visible when viewing the raw values.yaml file

## Example

```yaml
# serverHost is the host name for the webserver
serverHost: example
# serverPort is the HTTP listener port for the webserver
serverPort: 9191
```
