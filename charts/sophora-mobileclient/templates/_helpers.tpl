{{/*
Expand the name of the chart.
*/}}
{{- define "mobileclient.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mobileclient.fullname" -}}
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
{{- define "mobileclient.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mobileclient.labels" -}}
helm.sh/chart: {{ include "mobileclient.chart" . }}
{{ include "mobileclient.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mobileclient.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mobileclient.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Configmap Name
*/}}
{{- define "mobileclient.configName" -}}
{{- printf "%s-config" (include "mobileclient.fullname" . | trunc 56 | trimSuffix "-" ) -}}
{{- end }}

{{/*
Binary Configmap Name
*/}}
{{- define "mobileclient.binaryConfigName" -}}
{{- printf "%s-binary-config" (include "mobileclient.fullname" . | trunc 49 | trimSuffix "-" ) -}}
{{- end }}
