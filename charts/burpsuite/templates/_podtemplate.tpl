{{- define "burpsuite.podTemplate" -}}
metadata:
  annotations:
  {{- with .Values.pod.annotations }}
  {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
  {{- include "burpsuite.labels" . | nindent 4 }}
  {{- with .Values.pod.labels }}
  {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with .Values.pod.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  serviceAccountName: {{ include "burpsuite.serviceAccountName" . }}
  terminationGracePeriodSeconds: {{ .Values.pod.terminationGracePeriodSeconds }}
  {{- with .Values.podSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.initContainers }}
  initContainers:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  containers:
  - {{- include "burpsuite.enterprise.containerTemplate" . | nindent 4 }}
  - {{- include "burpsuite.web.containerTemplate" . | nindent 4 }}
  {{- with .Values.pod.affinity }}
  affinity:
    {{- tpl (toYaml .Values.pod.affinity) . | nindent 4 }}
  {{- end }}
  {{- with .Values.pod.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.pod.securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- tpl (toYaml .Values.topologySpreadConstraints) . | nindent 4 }}
  {{- end }}
  volumes:
  - name: home-burpsuite
    emptyDir:
      sizeLimit: 2Gi
{{- end }}