{{/*
Common environment variables 
*/}}
{{- define "sophora-image-service.commonEnv" -}}
- name: SOPHORA_CLIENT_SERVERCONNECTION_USERNAME
  valueFrom:
    secretKeyRef:
      key: {{ .Values.sophora.authentication.secret.usernameKey | quote }}
      name: {{ required "A valid secret name must be provided in .Values.sophora.authentication.secret.name" .Values.sophora.authentication.secret.name | quote }}
- name: SOPHORA_CLIENT_SERVERCONNECTION_PASSWORD
  valueFrom:
    secretKeyRef:
      key: {{ .Values.sophora.authentication.secret.passwordKey | quote }}
      name: {{ required "A valid secret name must be provided in .Values.sophora.authentication.secret.name" .Values.sophora.authentication.secret.name | quote }}
- name: S3_BUCKET_NAME
  value: {{ .Values.s3.bucketName | quote }}
- name: S3_ACCESS_KEY_ID
  valueFrom:
    secretKeyRef:
      name: {{ required "A valid secret name must be provided in .Values.s3.secret.name" .Values.s3.secret.name | quote }}
      key: {{ .Values.s3.secret.accessKeyIdKey | quote }}
- name: S3_SECRET_ACCESS_KEY
  valueFrom:
    secretKeyRef:
      name: {{ required "A valid secret name must be provided in .Values.s3.secret.name" .Values.s3.secret.name | quote }}
      key: {{ .Values.s3.secret.secretAccessKeyKey | quote }}
- name: TZ
  value: {{ .Values.timeZone | quote }}
{{- end }}