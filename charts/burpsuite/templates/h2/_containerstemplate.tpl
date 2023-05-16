{{- define "burpsuite.h2db.containerTemplate" -}}
- image: {{ include "burpsuite.web.image" . }}
  imagePullPolicy: Always
  name: h2
  command:
    - /usr/local/burpsuite_enterprise/jre/bin/java
  args:
    - -cp
    - /usr/local/burpsuite_enterprise/lib/h2-1.4.197.jar
    - org.h2.tools.Server
    - -tcp
    - -tcpPort
    - "9092"
  resources:
    requests:
      memory: 128Mi
      cpu: 100m
    limits:
      memory: 128Mi
  ports:
    - name: h2
      containerPort: 9092
  startupProbe:
    tcpSocket:
      port: h2
    failureThreshold: 60
    periodSeconds: 5
    timeoutSeconds: 2
  livenessProbe:
    tcpSocket:
      port: h2
    failureThreshold: 3
    periodSeconds: 10
    timeoutSeconds: 2
    successThreshold: 1
  readinessProbe:
    tcpSocket:
      port: h2
    failureThreshold: 1
    periodSeconds: 10
    timeoutSeconds: 2
    successThreshold: 1
  securityContext:
    capabilities:
      drop:
      - ALL
    readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
    runAsNonRoot: true
{{- end -}}