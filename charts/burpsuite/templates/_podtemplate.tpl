{{/*
Outputs a pod spec for use in different resources.
*/}}
{{- define "burpsuite.podTemplate" }}
metadata:
  annotations:
  {{- with .Values.pod.annotations }}
  {{- toYaml . | nindent 8 }}
  {{- end }}
  labels:
  {{- include "burpsuite.labels" . | nindent 8 }}
  {{- with .Values.pod.labels }}
  {{- toYaml . | nindent 8 }}
  {{- end }}
spec:
  {{- with .Values.pod.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  serviceAccountName: {{ include "burpsuite.serviceAccountName" . }}
  terminationGracePeriodSeconds: {{ .Values.pod.terminationGracePeriodSeconds }}
  {{- with .Values.podSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with .Values.initContainers }}
  initContainers:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  containers:
  - {{ include "burpsuite.enterprise.containerTemplate" . | nindent 8 }}
  {{- with .Values.pod.affinity }}
  affinity:
    {{- tpl (toYaml .Values.pod.affinity) . | nindent 8 }}
  {{- end }}
  {{- with .Values.pod.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- with .Values.pod.securityContext }}
  securityContext:
    {{- toYaml . | nindent 8 }}
  {{- end }}
  {{- if .Values.topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- tpl (toYaml .Values.topologySpreadConstraints) . | nindent 8 }}
  {{- end }}
  volumes:
  - name: {{ include "burpsuite.enterprise.fullname" . }}
    emptyDir: {}
{{- end }}