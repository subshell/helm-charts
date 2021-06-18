{{- define "sophora-server.mysqlEnv" -}}
{{ if eq .Values.sophora.server.persistence.repositoryType "mysql" -}}
{{- range $i, $repository := .Values.sophora.server.persistence.mysql.repositories }}
- name: REPOSITORY_MYSQL_HOST_{{ $i }}
  valueFrom:
    secretKeyRef:
      key: {{ required "MySQL hostname key must be provided in the form hostname:port" ($repository.hostnameKey | default "hostname") }}
      name: {{ $repository.secretName }}
      optional: false
- name: REPOSITORY_MYSQL_USER_{{ $i }}
  valueFrom:
    secretKeyRef:
      key: {{ ($repository.usernameKey | default "username") }}
      name: {{ $repository.secretName }}
      optional: false
- name: REPOSITORY_MYSQL_PASSWORD_{{ $i }}
  valueFrom:
    secretKeyRef:
      key: {{ ($repository.passwordKey | default "password") }}
      name: {{ $repository.secretName }}
      optional: false
{{ end }}
{{- end }}
{{ if eq .Values.sophora.server.persistence.archiveType "mysql" -}}
{{- range $i, $archive := .Values.sophora.server.persistence.mysql.archives }}
# archive
- name: ARCHIVE_MYSQL_HOST_{{ $i }}
  valueFrom:
    secretKeyRef:
      key: {{ required "MySQL hostname must be provided in the form hostname:port" ($archive.hostnameKey | default "hostname") }}
      name: {{ $archive.secretName }}
      optional: false
- name: ARCHIVE_MYSQL_USER_{{ $i }}
  valueFrom:
    secretKeyRef:
      key: {{ ($archive.usernameKey | default "username") }}
      name: {{ $archive.secretName }}
      optional: false
- name: ARCHIVE_MYSQL_PASSWORD_{{ $i }}
  valueFrom:
    secretKeyRef:
      key: {{ ($archive.passwordKey | default "password") }}
      name: {{ $archive.secretName }}
      optional: false
{{ end }}
{{- end }}
{{- end }}