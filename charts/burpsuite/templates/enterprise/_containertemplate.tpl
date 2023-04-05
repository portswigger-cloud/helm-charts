{{- define "burpsuite.enterprise.containerTemplate" }}
image: "{{ $values.image.name }}:{{ .Values.image.tag }}"
imagePullPolicy: Always
name: enterprise
resources:
  requests:
    memory:
    cpu:
  limits:
    memory:
ports:
{{- range $portName, $portSpec := .Values.ports }}
  - name: {{ $portName }}
    containerPort: {{ $portSpec.port }}
    protocol: {{ $portSpec.protocol }}
{{- end }}
startupProbe:
  {{- toYaml .Values.healthcheck | nindent 10 }}
  failureThreshold: 60
  periodSeconds: 5
  timeoutSeconds: 2
readinessProbe:
  {{- toYaml .Values.healthcheck | nindent 10 }}
  failureThreshold: 1
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 2
livenessProbe:
  {{- toYaml .Values.healthcheck | nindent 10 }}
  failureThreshold: 3
  periodSeconds: 10
  successThreshold: 1
  timeoutSeconds: 2
{{- with .Values.deployment.lifecycle }}
lifecycle:
  {{- toYaml . | nindent 10 }}
{{- end }}
securityContext:
  {{- toYaml .Values.securityContext | nindent 10 }}
{{- with .Values.args }}
args:
  {{- toYaml . | nindent 10 }}
{{- end }}
{{- with .Values.env }}
env:
  {{- toYaml . | nindent 10 }}
{{- end }}
{{- with .Values.envFrom }}
envFrom:
  {{- toYaml . | nindent 10 }}
{{- end }}
volumeMounts:
- mountPath: /tmp
  name: tmp-volume
{{- end }}