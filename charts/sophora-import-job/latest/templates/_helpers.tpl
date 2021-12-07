{{/*
Expand the name of the chart.
*/}}
{{- define "sophora-import-job.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sophora-import-job.fullname" -}}
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
{{- define "sophora-import-job.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sophora-import-job.labels" -}}
helm.sh/chart: {{ include "sophora-import-job.chart" . }}
{{ include "sophora-import-job.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sophora-import-job.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-import-job.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "sophora-import-job.utils.joinListWithSpace" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}}{{- " " -}}{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{- define "sophora-import-job.transformationLibsPath" -}}
/sophora/additionalLibs
{{- end -}}

{{- define "sophora-import-job.transformationXslPath" -}}
/sophora/xsl
{{- end -}}

{{- define "sophora-import-job.downloadTransformationsScript" -}}
start=$(date +%s%3N)

mkdir -p dl && cd dl || exit;
mkdir -p {{ include "sophora-import-job.transformationXslPath" . }}
mkdir -p {{ include "sophora-import-job.transformationLibsPath" . }}

# xsl and libs
{{ .Files.Get "scripts/download_zip.sh" }}
for file in `ls *.zip`; do unzip "$file"; done
rm *.zip;
mv ./{{ .Values.transformation.data.xslPath }}/* {{ include "sophora-import-job.transformationXslPath" . }}
mv ./{{ .Values.transformation.data.libsPath }}/* {{ include "sophora-import-job.transformationLibsPath" . }}

downloadEnd=$(date +%s%3N)
downloadDurationMillis=$((downloadEnd-start))
downloadDurationSeconds=$(awk -v millis=$downloadDurationMillis 'BEGIN { print ( millis / 1000 ) }')

# Write metrics to file
cat <<EOT >> /metrics/metrics.txt
sophora_import_job_download_duration_seconds{type="transformations"} $downloadDurationSeconds
EOT
{{- end -}}
