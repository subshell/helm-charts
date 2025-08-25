{{- define "sophora-server.postgresMutliEnv" -}}
{{- range $index, $podConfig := .Values.sophora.server.persistence.multiPostgres.byPodIndex }}
- name: SOPHORA_PERSISTENCE_POSTGRES_DATABASE_{{ $index }}
  value: {{ $podConfig.database }}
- name: SOPHORA_PERSISTENCE_POSTGRES_HOSTNAME_{{ $index }}
  value: {{ $podConfig.hostname }}
- name: SOPHORA_PERSISTENCE_POSTGRES_PORT_{{ $index }}
  value: {{ $podConfig.port | quote }}
{{- if $podConfig.username }}
- name: SOPHORA_PERSISTENCE_POSTGRES_USERNAME_{{ $index }}
  value: {{ $podConfig.username | quote }}
{{- end }}
{{- if $podConfig.secret.name }}
- name: SOPHORA_PERSISTENCE_POSTGRES_USERNAME_{{ $index }}
  valueFrom:
    secretKeyRef:
      key: {{ $podConfig.secret.usernameKey }}
      name: {{ $podConfig.secret.name }}
      optional: false
- name: SOPHORA_PERSISTENCE_POSTGRES_PASSWORD_{{ $index }}
  valueFrom:
    secretKeyRef:
      key: {{ $podConfig.secret.passwordKey }}
      name: {{ $podConfig.secret.name }}
      optional: false
{{- end }}
{{- with $podConfig.repository }}
- name: JCR_REPOSITORY_DEFAULT_POSTGRES_DB_{{ $index }}
  value: {{ default "repository" .defaultWorkspaceDB  }}
- name: JCR_REPOSITORY_LIVE_POSTGRES_DB_{{ $index }}
  value: {{ default "repository" .liveWorkspaceDB }}
- name: JCR_REPOSITORY_VERSIONS_POSTGRES_DB_{{ $index }}
  value: {{ default "repository" .jcrVersionsDB }}
{{- end }}
{{- end }}
{{- end }}
