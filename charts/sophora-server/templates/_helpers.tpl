{{/*
Expand the name of the chart.
*/}}
{{- define "sophora-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sophora-server.fullname" -}}
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
{{- define "sophora-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sophora-server.labels" -}}
helm.sh/chart: {{ include "sophora-server.chart" . }}
{{ include "sophora-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common Top-Level labels
*/}}
{{- define "sophora-server.topLevelLabels" -}}
{{ include "sophora-server.labels" . }}
{{- if .Values.topLevelLabels }}
{{ toYaml .Values.topLevelLabels }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sophora-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Values.additionalSelectorLabels }}
{{ toYaml .Values.additionalSelectorLabels }}
{{- end }}
{{- end }}

{{/*
Load Balancer service labels
*/}}
{{- define "sophora-server.loadBalancerLabels" -}}
sophora.cloud/service-type: loadBalancer
{{- end }}

{{/*
Server configs and scripts config map name
*/}}
{{- define "sophora-server.configs" -}}
{{- printf "properties-template-%s" (include "sophora-server.fullname" .) | trunc 63 -}}
{{- end }}

{{/*
Properties Name
*/}}
{{- define "sophora-server.propertiesName" -}}
{{- printf "properties-%s" (include "sophora-server.fullname" .) | trunc 63 -}}
{{- end }}

{{/*
Repository Template Name
*/}}
{{- define "sophora-server.repositoryConfigTemplateName" -}}
{{- printf "repository-template-%s" (include "sophora-server.fullname" .) | trunc 63 -}}
{{- end }}

{{/*
Repository-Config Name
*/}}
{{- define "sophora-server.repositoryConfigName" -}}
{{- printf "repository-%s" (include "sophora-server.fullname" .) | trunc 63 -}}
{{- end }}

{{/*
Archive Template Name
*/}}
{{- define "sophora-server.archiveConfigTemplateName" -}}
{{- printf "archive-template-%s" (include "sophora-server.fullname" .) | trunc 63 -}}
{{- end }}

{{/*
Archive-Config Name
*/}}
{{- define "sophora-server.archiveConfigName" -}}
{{- printf "archive-%s" (include "sophora-server.fullname" .) | trunc 63 -}}
{{- end }}

{{/*
Logback-Config Name
*/}}
{{- define "sophora-server.logbackConfigName" -}}
{{- printf "logback-%s" (include "sophora-server.fullname" .) | trunc 63 -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sophora-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sophora-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}


{{- define "common.safeSuffixFullname" -}}
    {{- $ctx := index . 0 -}}
    {{- $suffix := index . 1 -}}
    {{- printf "%s-%s" (include "sophora-server.fullname" $ctx | trunc (sub 62 (len $suffix) | int)) $suffix }}
{{- end -}}
