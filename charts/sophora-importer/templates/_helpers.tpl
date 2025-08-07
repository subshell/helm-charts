{{/*
Expand the name of the chart.
*/}}
{{- define "sophora-importer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sophora-importer.fullname" -}}
{{- if .Values.fullNameOverride }}
{{- .Values.fullNameOverride | trunc 63 | trimSuffix "-" }}
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
{{- define "sophora-importer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sophora-importer.labels" -}}
helm.sh/chart: {{ include "sophora-importer.chart" . }}
{{ include "sophora-importer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sophora-importer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-importer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sophora-importer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sophora-importer.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "sophora-importer.utils.joinListWithSpace" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}}{{- " " -}}{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}


{{- define "sophora-importer.transformationLibsPath" -}}
/sophora/additionalLibs
{{- end -}}

{{- define "sophora-importer.transformationXslPath" -}}
/sophora/xsl
{{- end -}}

{{- define "sophora-importer.downloadTransformationsScript" -}}
mkdir -p dl && cd dl || exit;
mkdir -p {{ include "sophora-importer.transformationXslPath" . }}
mkdir -p {{ include "sophora-importer.transformationLibsPath" . }}

# xsl and libs
{{ .Files.Get "scripts/download_zip.sh" }}
for file in `ls *.zip`; do unzip "$file"; done
rm *.zip;
mv ./{{ .Values.transformation.data.xslPath }}/* {{ include "sophora-importer.transformationXslPath" . }}
mv ./{{ .Values.transformation.data.libsPath }}/* {{ include "sophora-importer.transformationLibsPath" . }}
{{- end -}}


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
