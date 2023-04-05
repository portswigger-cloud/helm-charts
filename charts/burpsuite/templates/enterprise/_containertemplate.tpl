{{- define "burpsuite.enterprise.containerTemplate" }}
image: {{ include "burpsuite.enterprise.image" . }}
imagePullPolicy: Always
name: enterprise
resources:
  requests:
    memory:
    cpu:
  limits:
    memory:
ports:
  - name: web-server-api
    containerPort: 8072
    protocol: TCP
startupProbe:
  tcpSocket:
    port: web-server-api
  failureThreshold: 60
  periodSeconds: 5
  timeoutSeconds: 2
livenessProbe:
  tcpSocket:
    port: web-server-api
  failureThreshold: 3
  periodSeconds: 10
  timeoutSeconds: 2
  successThreshold: 1
readinessProbe:
  tcpSocket:
    port: web-server-api
  failureThreshold: 1
  periodSeconds: 10
  timeoutSeconds: 2
  successThreshold: 1
securityContext:
  {{- toYaml .Values.enterprise.securityContext | nindent 2 }}
envFrom:
  - configMapRef:
      name: {{ include "burpsuite.enterprise.fullname" . }}
  - secretRef:
      name: {{ include "burpsuite.enterprise.fullname" . }}
volumeMounts:
- mountPath: /home/burpsuite
  name: {{ include "burpsuite.enterprise.fullname" . }}
{{- end }}