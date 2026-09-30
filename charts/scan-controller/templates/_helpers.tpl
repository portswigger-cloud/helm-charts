{{/*
Expand the name of the chart.
*/}}
{{- define "scan-controller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scan-controller.fullname" -}}
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
{{- define "scan-controller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scan-controller.labels" -}}
helm.sh/chart: {{ include "scan-controller.chart" . }}
{{ include "scan-controller.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scan-controller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scan-controller.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "scan-controller.scanner.selectorLabels" -}}
app.kubernetes.io/component: {{ include "scan-controller.name" . }}-scanner
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Renders a value that contains template.
Usage:
{{ include "scan-controller.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "scan-controller.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{- define "scan-controller.controller.version" -}}
{{- coalesce .Values.controller.image.tag .Values.global.image.tag .Chart.AppVersion }}
{{- end -}}

{{- define "scan-controller.controller.image" -}}
{{- if .Values.controller.image.sha256 -}}
{{- printf "%s/%s:%s@sha256:%s" (.Values.controller.image.registry | default .Values.global.image.registry) .Values.controller.image.repository (include "scan-controller.controller.version" .) (trimPrefix "sha256:" .Values.controller.image.sha256) }}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.controller.image.registry | default .Values.global.image.registry) .Values.controller.image.repository (include "scan-controller.controller.version" .) }}
{{- end -}}
{{- end -}}

{{- define "scan-controller.scanner.version" -}}
{{- coalesce .Values.scanner.image.tag .Values.global.image.tag .Chart.AppVersion }}
{{- end -}}

{{- define "scan-controller.scanner.image" -}}
{{- if .Values.scanner.image.sha256 -}}
{{- printf "%s/%s:%s@sha256:%s" (.Values.scanner.image.registry | default .Values.global.image.registry) .Values.scanner.image.repository (include "scan-controller.scanner.version" .) (trimPrefix "sha256:" .Values.scanner.image.sha256) }}
{{- else -}}
{{- printf "%s/%s:%s" (.Values.scanner.image.registry | default .Values.global.image.registry) .Values.scanner.image.repository (include "scan-controller.scanner.version" .) }}
{{- end -}}
{{- end -}}
