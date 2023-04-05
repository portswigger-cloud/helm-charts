{{- define "burpsuite.database.url" -}}
{{/*{{- if .Values.postgresql.enabled }}*/}}
{{/*jdbc:postgresql://{{ include "postgresql.primary.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ template "postgresql.service.port" . }}*/}}
{{/*{{- else if .Values.database.externalUrl -}}*/}}
{{/*{{ .Values.database.externalUrl }}*/}}
{{/*{{- end -}}*/}}
{{- end -}}

{{- define "burpsuite.enterprise.secretValue" -}}
{{- $context := index . 0 -}}
{{- $suppliedValue := index . 1 -}}
{{- $secretFieldName := index . 2 -}}

{{- if $suppliedValue -}}
{{ $suppliedValue | b64enc }}
{{- else if $context.Values.postgresql.enabled -}}
{{- include "burpsuite.enterprise.fetchOrCreateSecretField"  (list $context $secretFieldName) -}}
{{- end -}}
{{- end -}}