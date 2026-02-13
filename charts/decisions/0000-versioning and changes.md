# Version Changes to Helm Charts

| <!-- -->  | <!-- -->                                                    |
|-----------|-------------------------------------------------------------|
| status    | accepted                                                    |
| date      | ?                                                           |
| deciders  | subshell                                                    |
| consulted | ?                                                           |
| informed  | subshell developers                                         |
| <!-- -->  | <!-- -->                                                    |

## Context and Problem Statement

Each Helm chart has a version. When changing charts the version must be updated to make the change clear.

The GitHub pipeline is triggered for all changed files on the main branch. To release these changes a unique version number must be set.

## Decision Outcome

We use semantic versioning in our Helm charts. All feature branches and pull requests must increment the chart version of all modified charts.

Increment the patch version for small fixes and documentation updates. Increment the minor version for added features. The major version should be incremented for breaking changes like removing or renaming values to indicate that they are not compatible with the previous major version.
