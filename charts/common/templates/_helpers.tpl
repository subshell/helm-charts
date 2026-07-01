{{/*
Generate the name for a resource by adding a suffix.
The name is composed of the chart's full release name and the a suffix,
truncated to 63 characters as required by Kubernetes DNS naming rules.

Usage:
  {{ include "common.suffixName.name" (dict "fullName" $fullName "suffix" $key) }}
*/}}
{{- define "common.suffixName.name" -}}
{{- printf "%s-%s" .fullName .suffix | trunc 63 | trimSuffix "-" -}}
{{- end -}}
