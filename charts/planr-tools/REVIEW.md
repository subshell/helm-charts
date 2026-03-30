# planr-tools Chart Review — Round 2

Feedback from [subshell/helm-charts#267](https://github.com/subshell/helm-charts/pull/267). Remove this file before merging.

## 🔴 High Severity

- ✅ **#1 — HTTPRoute does not strip path prefix** (`templates/httproute.yaml`)
  Like the Ingress, the HTTPRoute currently forwards requests with the external prefix still present
  (e.g. `/document-creator/api/...`). Add a per-rule `URLRewrite` filter to strip the prefix:
  ```yaml
  filters:
  - type: URLRewrite
    urlRewrite:
      path:
        type: ReplacePrefixMatch
        replacePrefixMatch: /
  ```
  Note: only needed for non-root exposure paths, widget's `/` is fine as-is.

- ⬜ **#2 — Config checksum uses raw (untemplated) values** (`templates/_helpers.tpl`)
  `planr-tools.componentConfigChecksum` hashes the raw `.component.config` map, but the ConfigMap
  renders config via `tpl`. If config contains `${...}` placeholders referencing env vars, changing
  those env vars won't change the checksum and pods won't restart. Compute the checksum from the
  fully rendered `application.yml` content instead.

## 🟡 Medium Severity

- ✅ **#3 — Hardcoded app key list — centralize in `_helpers.tpl`** (`templates/configmap.yaml` et al.)
  DanielRaapDev suggests declaring the list once in `_helpers.tpl` and including it via
  `include "planr-tools.app-keys" .` — revisit the `fromYaml` approach discussed earlier.

- ✅ **#4 — Wrap nginx annotations behind `ingressClassName` guard** (`templates/ingress.yaml`)
  Wrap the `nginx.ingress.kubernetes.io/*` annotations in
  `{{- if eq "nginx" .Values.ingress.ingressClassName }}` so they're not emitted when using a
  different ingress controller.

- ✅ **#5 — `ingress.pathType` defined in values but never used** (`values.yaml`)
  The template hardcodes `pathType: ImplementationSpecific`. Either remove `ingress.pathType` from
  `values.yaml` or wire it back into the template.

- ⬜ **#6 — Actuator endpoints too broad by default** (`values.yaml`) 🔓
  The default config exposes `jolokia` and `endpoints` over HTTP which can become externally
  reachable via Ingress/HTTPRoute. Restrict defaults to `health, info` and make extras opt-in.

## 🟢 Low Severity

- ⬜ **#7 — README: document required secret and its keys** (`README.md`)
  Rename the example secret to `planr-tools-sophora-credentials` and document that it is required,
  listing the expected keys (`username`, `password`).

- ⬜ **#8 — README: document Ingress controller requirements** (`README.md`)
  Note that the Ingress only works with controllers that support regex for
  `pathType: ImplementationSpecific` and allow `rewrite-target` with capture groups (e.g. nginx).

- ⬜ **#9 — No unit tests for Ingress template** (`tests/`)
  Add assertions for the nginx annotations, the three regex paths, and the service backends.

- ⬜ **#10 — HTTPRoute test does not assert path values** (`tests/httproute_test.yaml`)
  Add assertions for `spec.rules[*].matches[0].path.value` (`/document-creator`, `/feed`, `/`).

- ⬜ **#11 — Empty `value:` fields produce null EnvVars** (`test-values-ingress.yaml`)
  `value: # in secret` becomes `value: null` which is an invalid Kubernetes EnvVar. Use `value: ""`
  or switch the examples to `valueFrom.secretKeyRef`.

- ⬜ **#12 — Fix test name grammar** (`tests/deployment_test.yaml`)
  Rename `should not failedTemplate` → `should render without errors`.

- ⬜ **#13 — Remove `REVIEW.md` before merging** 🗑️
