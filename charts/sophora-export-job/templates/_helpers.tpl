{{/*
Expand the name of the chart.
*/}}
{{- define "sophora-export-job.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sophora-export-job.fullname" -}}
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
{{- define "sophora-export-job.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sophora-export-job.labels" -}}
helm.sh/chart: {{ include "sophora-export-job.chart" . }}
{{ include "sophora-export-job.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "sophora-export-job.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sophora-export-job.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "sophora-export-job.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sophora-export-job.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "sophora-export-job.utils.joinListWithSpace" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}}{{- " " -}}{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{- define "sophora-export-job.utils.fileNameWithoutZipExtension" -}}
{{- if hasSuffix ".zip" .Values.upload.absoluteFilePath }}
{{- printf "%s" (regexSplit ".zip" .Values.upload.absoluteFilePath -1 | first) }}
{{- else }}
{{- printf "%s" .Values.upload.absoluteFilePath }}
{{- end }}
{{- end }}

{{- define "sophora-export-job.utils.upload-to-s3-env" -}}
- name: AWS_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      key: {{.Values.s3.secret.accessKeyIdKey}}
      name: {{ .Values.s3.secret.name }}
- name: AWS_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      key: {{.Values.s3.secret.secretAccessKeyKey}}
      name: {{ .Values.s3.secret.name }}
- name: S3_ENDPOINT
  value: {{ .Values.s3.url }}
- name: S3_NAME
  value: {{ .Values.s3.name }}
- name: S3_FILE_PATH_WITHOUT_EXTENSION
  value: {{ include "sophora-export-job.utils.fileNameWithoutZipExtension" . | quote }}
- name: ZIP_FILE_NAME_DATE_FORMAT
  value: {{ .Values.job.zipFileNameDateFormat | quote }}
- name: CRON_JOB
  value: {{ .Values.job.cron.enabled | quote }}
- name: PUSHGATEWAY_BASE_URL
  value: {{ .Values.metrics.pushgatewayUrl | quote }}
- name: JOB_NAME
  value: {{ include "sophora-export-job.fullname" . | quote }}
{{- if .Values.metrics.authentication.secret.name }}
- name: PUSHGATEWAY_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ .Values.metrics.authentication.secret.name | quote }}
      key: {{ .Values.metrics.authentication.secret.usernameKey | quote }}
- name: PUSHGATEWAY_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.metrics.authentication.secret.name | quote }}
      key: {{ .Values.metrics.authentication.secret.usernameKey | quote }}
  {{- end }}
{{- end }}

{{- define "sophora-export-job.utils.upload-to-s3-container" -}}
name: upload
image: "{{ .Values.upload.image.repository }}:{{ .Values.upload.image.tag }}"
imagePullPolicy: {{ .Values.upload.image.pullPolicy }}
env: {{ include "sophora-export-job.utils.upload-to-s3-env" . | nindent 2 }}
command: ["/bin/sh"]
args:
  - "-c"
  - |-
    sh /exporter-configmap/wait-for-exporter-to-finish.sh
    sh /exporter-configmap/upload-to-s3.sh
volumeMounts:
  - name: data-export
    mountPath: /data-export
  - name: exporter-configmap
    mountPath: /exporter-configmap
  - name: metrics
    mountPath: /metrics
securityContext:
  capabilities:
    add:
      - SYS_PTRACE
{{- end }}