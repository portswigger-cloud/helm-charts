{{/*
Expand the name of the chart.
*/}}
{{- define "burpsuite.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified web app name.
*/}}
{{- define "burpsuite.web.fullname" -}}
{{- $name := include "burpsuite.fullname" . | trunc 59 | trimSuffix "-" }}
{{- printf "%s-web" $name }}
{{- end }}

{{/*
Create a default fully qualified enterprise app name.
*/}}
{{- define "burpsuite.enterprise.fullname" -}}
{{- $name := include "burpsuite.fullname" . | trunc 52 | trimSuffix "-" }}
{{- printf "%s-enterprise" $name }}
{{- end }}

{{- define "burpsuite.enterprise.image" -}}
{{- printf "%s/%s:%s" (.Values.enterprise.image.registry | default .Values.global.image.registry) .Values.enterprise.image.repository (coalesce .Values.enterprise.image.tag .Values.global.image.tag .Chart.AppVersion) }}
{{- end -}}

{{- define "burpsuite.web.image" -}}
{{- printf "%s/%s:%s" (.Values.web.image.registry | default .Values.global.image.registry) .Values.web.image.repository (coalesce .Values.web.image.tag .Values.global.image.tag .Chart.AppVersion) }}
{{- end -}}

{{- define "burpsuite.agent.image" -}}
{{- printf "%s/%s:%s" (.Values.agent.image.registry | default .Values.global.image.registry) .Values.agent.image.repository (coalesce .Values.agent.image.tag .Values.global.image.tag .Chart.AppVersion) }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "burpsuite.fullname" -}}
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
{{- define "burpsuite.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "burpsuite.labels" -}}
helm.sh/chart: {{ include "burpsuite.chart" . }}
{{ include "burpsuite.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "burpsuite.selectorLabels" -}}
app.kubernetes.io/name: {{ include "burpsuite.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "burpsuite.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "burpsuite.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Fetch given field from existing enterprise secret or generate a new random value
*/}}
{{- define "burpsuite.enterprise.fetchOrCreateSecretField" -}}
{{- $context := index . 0 -}}
{{- $secretFieldName := index . 1 -}}

{{- $secretName := include "burpsuite.enterprise.fullname" $context }}
{{- $secretObj := (lookup "v1" "Secret" $context.Release.Namespace $secretName) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $secretFieldValue := (get $secretData $secretFieldName) | default (randAlphaNum 30 | b64enc) }}
{{- $secretFieldValue -}}
{{- end -}}

{{- define "burpsuite.enterprise.secretValue" -}}
{{- $context := index . 0 -}}
{{- $suppliedValue := index . 1 -}}
{{- $secretFieldName := index . 2 -}}
{{- if $suppliedValue -}}
{{ $suppliedValue | b64enc }}
{{- else if $context.Values.postgres.enabled -}}
{{ include "burpsuite.enterprise.fetchOrCreateSecretField"  (list $context $secretFieldName) }}
{{- end -}}
{{- end -}}


{{- define "burpsuite.database.url" -}}
{{- if .Values.postgres.enabled -}}
{{ printf "jdbc:postgresql://%s-postgres.%s.svc.cluster.local:%v/%v" .Release.Name .Release.Namespace .Values.postgres.service.port .Values.postgres.userDatabase.name }}
{{- else if .Values.database.externalUrl -}}
{{ .Values.database.externalUrl }}
{{- end -}}
{{- end -}}

