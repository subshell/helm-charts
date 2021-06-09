{{/*
Expand the name of the chart.
*/}}
{{- define "sophora-image-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "sophora-image-access-service.name" -}}
{{- printf "%s-access" (include "sophora-image-service.name" .) }}
{{- end }}

{{- define "sophora-image-update-service.name" -}}
{{- printf "%s-update" (include "sophora-image-service.name" .) }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sophora-image-service.fullname" -}}
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

{{- define "sophora-image-access-service.fullname" -}}
{{- printf "%s-access" (include "sophora-image-service.fullname" .) }}
{{- end }}

{{- define "sophora-image-update-service.fullname" -}}
{{- printf "%s-update" (include "sophora-image-service.fullname" .) }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sophora-image-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sophora-image-service.labels" -}}
helm.sh/chart: {{ include "sophora-image-service.chart" . }}
{{ include "sophora-image-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "sophora-image-access-service.labels" -}}
helm.sh/chart: {{ include "sophora-image-service.chart" . }}
{{ include "sophora-image-access-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "sophora-image-update-service.labels" -}}
helm.sh/chart: {{ include "sophora-image-service.chart" . }}
{{ include "sophora-image-update-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sophora-image-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-image-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "sophora-image-access-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-image-access-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "sophora-image-update-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-image-update-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sophora-image-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sophora-image-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
