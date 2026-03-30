# planr-tools Chart Review

Code review of the initial chart implementation. Work through these items top to bottom.

## 🔴 High Severity

- ✅ **#1 — Missing liveness/readiness probes** (`templates/deployment.yaml`)
  Add `livenessProbe`, `readinessProbe`, and `startupProbe` referencing the Spring Boot actuator
  endpoints (`/actuator/health/liveness`, `/actuator/health/readiness`) — as done in `sophora-ai`.
  Without probes, failed pods are never restarted and never removed from load balancing. 💀

- ✅ **#2 — Default `service.type: LoadBalancer`** (`values.yaml` — all three applications)
  Will provision three ☁️ cloud load balancers on a default install. Since the chart is designed for
  path-based routing via Ingress or HTTPRoute, `ClusterIP` should be the default.
  (`test-values.yaml` already overrides this, confirming the default is wrong.)

## 🟡 Medium Severity

- ✅ **#3 — `JAVA_OPTS` env var name** (`templates/deployment.yaml`)
  Verified: all three Dockerfiles use `JAVA_OPTS` directly in their `ENTRYPOINT`. No change needed.

- ✅ **#4 — Missing `annotations.artifacthub.io/changes`** (`Chart.yaml`)
  Every other chart in the repo has this annotation; the release workflow likely depends on it 🚀.
  Add an initial entry, e.g.:
  ```yaml
  annotations:
    artifacthub.io/changes: |
      - kind: added
        description: Initial release of the planr-tools chart.
  ```

- ✅ **#5 — `sources` URL points to the application repo, not the chart repo** (`Chart.yaml`)
  All other charts set `sources` to `https://github.com/subshell/helm-charts/tree/main/charts/<name>`.
  The application GitLab URL belongs in `home`, not `sources`. 🏠

- ✅ **#6 — Hardcoded component list repeated across 5 template files** 🔁
  A shared helper would require a non-obvious `fromYaml` wrapper pattern. Accepted as intentional
  duplication instead — added a comment to each file explaining the ordering requirement and
  listing the files that need to stay in sync.

## 🟢 Low Severity

- ✅ **#7 — Thin test coverage** (`tests/`) 🧪
  Only the HTTPRoute is tested. The existing test checks backend names by index but not the path
  values (`/document-creator`, `/feed`, `/`) that are the core routing logic. Consider adding:
  - Path value assertions to the existing httproute test
  - At least a smoke test for Deployment and Ingress

- ✅ **#8 — `test-values.yaml` enables both `ingress` and `httpRoute` simultaneously** 🤷
  Replaced with `test-values-ingress.yaml` and `test-values-httproute.yaml`.

- ⏭️ **#9 — Missing `icon` field** (`Chart.yaml`) 🖼️
  Skipped — no icon available for this customer-specific chart.
