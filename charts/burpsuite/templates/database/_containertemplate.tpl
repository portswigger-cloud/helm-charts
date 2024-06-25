{{- define "burpsuite.database.containerTemplate" -}}
- image: {{ include "burpsuite.database.image" . }}
  imagePullPolicy: Always
  name: database
  resources:
    requests:
      memory: 128Mi
      cpu: 100m
      ephemeral-storage: 32Mi
    limits:
      memory: 128Mi
  ports:
    - name: postgres
      containerPort: 5432
  startupProbe:
    tcpSocket:
      port: postgres
    failureThreshold: 60
    periodSeconds: 5
    timeoutSeconds: 2
  livenessProbe:
    tcpSocket:
      port: postgres
    failureThreshold: 3
    periodSeconds: 10
    timeoutSeconds: 2
    successThreshold: 1
  readinessProbe:
    tcpSocket:
      port: postgres
    failureThreshold: 1
    periodSeconds: 10
    timeoutSeconds: 2
    successThreshold: 1
  envFrom:
    - secretRef:
        name: database-env
  volumeMounts:
    - name: database-vol
      mountPath: /docker-entrypoint-initdb.d
  securityContext:
    runAsUser: 999
    runAsGroup: 999
    capabilities:
      drop:
      - ALL
    readOnlyRootFilesystem: false
    allowPrivilegeEscalation: false
    runAsNonRoot: true
{{- end -}}