{{/*
Expand the name of the chart.
*/}}
{{- define "deskclient-downloads.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "deskclient-downloads.fullname" -}}
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
{{- define "deskclient-downloads.updatesiteUrl" -}}
{{- with .Values.sophoraDownload }}
{{- $majorVersion := regexSplit "\\." .version -1 | first }}
{{- printf  "%s/%s/deskclient-%s/sophora-deskclient-%s-%s-updatesite.zip" .baseUrl $majorVersion .version .version .identifier }}
{{- end }}
{{- end }}

{{/*
Creates the full windows deskclient url which points to a .zip file
*/}}
{{- define "deskclient-downloads.windowsDeskclientUrl" -}}
{{- with .Values.sophoraDownload }}
{{- $majorVersion := regexSplit "\\." .version -1 | first }}
{{- printf  "%s/%s/deskclient-%s/sophora-deskclient-%s-%s-win32.win32.x86_64.zip" .baseUrl $majorVersion .version .version .identifier }}
{{- end }}
{{- end }}

{{/*
Creates the full macOS deskclient url which points to a .dmg file
*/}}
{{- define "deskclient-downloads.macDeskclientUrl" -}}
{{- with .Values.sophoraDownload }}
{{- $majorVersion := regexSplit "\\." .version -1 | first }}
{{- printf  "%s/%s/deskclient-%s/sophora-deskclient-%s-%s-macosx.cocoa.x86_64.dmg" .baseUrl $majorVersion .version .version .identifier }}
{{- end }}
{{- end }}

{{/*
Creates the full Linux deskclient url which points to a .zip file
*/}}
{{- define "deskclient-downloads.linuxDeskclientUrl" -}}
{{- with .Values.sophoraDownload }}
{{- $majorVersion := regexSplit "\\." .version -1 | first }}
{{- printf  "%s/%s/deskclient-%s/sophora-deskclient-%s-%s-linux.gtk.x86_64.zip" .baseUrl $majorVersion .version .version .identifier }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "deskclient-downloads.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "deskclient-downloads.labels" -}}
helm.sh/chart: {{ include "deskclient-downloads.chart" . }}
{{ include "deskclient-downloads.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "deskclient-downloads.selectorLabels" -}}
app.kubernetes.io/name: {{ include "deskclient-downloads.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
