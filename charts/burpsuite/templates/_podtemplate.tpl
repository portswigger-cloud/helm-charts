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
  terminationGracePeriodSeconds: 10
  securityContext:
    runAsUser: 42877
    fsGroup: 42877
  initContainers:
    {{- include "burpsuite.enterprise.initContainerTemplates" . | nindent 4 }}
    {{- include "burpsuite.web.initContainerTemplates" . | nindent 4 }}
  containers:
    {{- include "burpsuite.enterprise.containerTemplate" . | nindent 4 }}
    {{- include "burpsuite.web.containerTemplate" . | nindent 4 }}
    {{- include "burpsuite.h2db.containerTemplate" . | nindent 4 }}
  {{- with .Values.pod.affinity }}
  affinity:
    {{- tpl (toYaml .Values.pod.affinity) . | nindent 4 }}
  {{- end }}
  {{- with .Values.pod.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.pod.tolerations }}
  tolerations:
  {{- toYaml . | nindent 2 }}
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