{{/*
Expand the name of the chart.
*/}}
{{- define "sophora-updatesite.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sophora-updatesite.fullname" -}}
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
Creates the full updatesite url which points to a .zip file
*/}}
{{- define "sophora-updatesite.updatesiteUrl" -}}
{{- with .Values.updatesiteDownload }}
{{- if .zipUrlOverride }}
{{- .zipUrlOverride }}
{{- else }}
{{- $majorVersion := regexSplit "\\." .version -1 | first }}
{{- printf  "%s/%s/deskclient-%s/sophora-deskclient-%s-%s.zip" .baseUrl $majorVersion .version .version .identifier }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sophora-updatesite.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sophora-updatesite.labels" -}}
helm.sh/chart: {{ include "sophora-updatesite.chart" . }}
{{ include "sophora-updatesite.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sophora-updatesite.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-updatesite.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
