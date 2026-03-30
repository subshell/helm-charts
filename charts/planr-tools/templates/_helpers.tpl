{{/*
Expand the name of the chart.
*/}}
{{- define "planr-tools.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "planr-tools.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "planr-tools.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "planr-tools.labels" -}}
helm.sh/chart: {{ include "planr-tools.chart" .root }}
{{ include "planr-tools.selectorLabels" . }}
{{- if .root.Chart.AppVersion }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "planr-tools.selectorLabels" -}}
app.kubernetes.io/name: {{ include "planr-tools.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ .component.name }}
{{- end }}

{{/*
Service account name.
*/}}
{{- define "planr-tools.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "planr-tools.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Ordered list of application keys.
Wrapped in a map because fromYaml requires a top-level map, not a bare list.
Usage: range $appKey := (include "planr-tools.app-keys" . | fromYaml).keys
*/}}
{{- define "planr-tools.app-keys" -}}
keys:
  - documentCreator
  - feed
  - widget
{{- end }}

{{/*
Component fullname.
*/}}
{{- define "planr-tools.componentFullname" -}}
{{- printf "%s-%s" (include "planr-tools.fullname" .root) .component.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Component configmap name.
*/}}
{{- define "planr-tools.componentConfigName" -}}
{{- printf "%s-config" (include "planr-tools.componentFullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Config checksum.
Computed from the fully rendered application.yml (after tpl), not the raw config map,
so that changes to values referenced inside config templates also trigger pod restarts.
*/}}
{{- define "planr-tools.componentConfigChecksum" -}}
{{- include "planr-tools.render" (dict "value" .component.config "context" .root) | sha256sum }}
{{- end }}

{{/*
Renders a value that contains templates.
*/}}
{{- define "planr-tools.render" -}}
{{- if typeIs "string" .value }}
{{- tpl .value .context }}
{{- else }}
{{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end -}}
