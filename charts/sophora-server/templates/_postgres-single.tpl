{{- define "sophora-server.postgresSingleEvn" -}}
- name: SOPHORA_PERSISTENCE_POSTGRES_HOSTNAME
  value: {{ .Values.sophora.server.persistence.postgres.hostname }}
- name: SOPHORA_PERSISTENCE_POSTGRES_PORT
  value: {{ .Values.sophora.server.persistence.postgres.port | quote }}
{{- if .Values.sophora.server.persistence.postgres.username }}
- name: SOPHORA_PERSISTENCE_POSTGRES_USERNAME
  value: {{ .Values.sophora.server.persistence.postgres.username | quote }}
{{- end }}
{{- if .Values.sophora.server.persistence.postgres.secret.name }}
- name: SOPHORA_PERSISTENCE_POSTGRES_USERNAME
  valueFrom:
    secretKeyRef:
      key: {{ .Values.sophora.server.persistence.postgres.secret.usernameKey }}
      name: {{ .Values.sophora.server.persistence.postgres.secret.name }}
      optional: false
- name: SOPHORA_PERSISTENCE_POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      key: {{ .Values.sophora.server.persistence.postgres.secret.passwordKey }}
      name: {{ .Values.sophora.server.persistence.postgres.secret.name }}
      optional: false
{{- end }}
- name: JCR_REPOSITORY_DEFAULT_POSTGRES_DB
  value: {{ .Values.sophora.server.persistence.postgres.repository.defaultWorkspaceDB }}
- name: JCR_REPOSITORY_LIVE_POSTGRES_DB
  value: {{ .Values.sophora.server.persistence.postgres.repository.liveWorkspaceDB }}
- name: JCR_REPOSITORY_VERSIONS_POSTGRES_DB
  value: {{ .Values.sophora.server.persistence.postgres.repository.jcrVersionsDB }}
{{- end }}
