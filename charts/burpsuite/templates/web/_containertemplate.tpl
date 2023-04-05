{{- define "burpsuite.web.containerTemplate" -}}
image: {{ include "burpsuite.web.image" . }}
imagePullPolicy: Always
name: web
resources:
  requests:
    memory:
    cpu:
  limits:
    memory:
ports:
- containerPort: 8080
  name: http
- containerPort: 8081
  name: health
startupProbe:
  httpGet:
    port: health
    path: /liveness/check
  failureThreshold: 60
  periodSeconds: 5
  timeoutSeconds: 2
livenessProbe:
  httpGet:
    port: health
    path: /liveness/check
  failureThreshold: 3
  periodSeconds: 10
  timeoutSeconds: 2
  successThreshold: 1
readinessProbe:
  httpGet:
    port: health
    path: /liveness/check
  failureThreshold: 1
  periodSeconds: 10
  timeoutSeconds: 2
  successThreshold: 1
securityContext:
  {{- toYaml .Values.web.securityContext | nindent 2 }}
envFrom:
  - configMapRef:
      name: {{ include "burpsuite.web.fullname" . }}
  - secretRef:
      name: {{ include "burpsuite.web.fullname" . }}
volumeMounts:
- mountPath: /home/burpsuite
  name: home-burpsuite
{{- end -}}