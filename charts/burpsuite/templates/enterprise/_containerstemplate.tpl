{{- define "burpsuite.enterprise.containerTemplate" -}}
- image: {{ include "burpsuite.enterprise.image" . }}
  imagePullPolicy: Always
  name: enterprise
  resources:
    requests:
      memory: 1.5Gi
      cpu: 200m
    limits:
      memory: 1.5Gi
  ports:
    - name: ent-api
      containerPort: 8072
    - name: ent-health
      containerPort: 8078
  startupProbe:
    httpGet:
      port: ent-health
      path: /health/readiness
    failureThreshold: 60
    periodSeconds: 5
    timeoutSeconds: 2
  livenessProbe:
    httpGet:
      port: ent-health
      path: /health/liveness
    failureThreshold: 3
    periodSeconds: 10
    timeoutSeconds: 2
    successThreshold: 1
  readinessProbe:
    httpGet:
      port: ent-health
      path: /health/readiness
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
  envFrom:
    - configMapRef:
        name: enterprise-env
    - secretRef:
        name: enterprise-env
    {{- with .Values.enterprise.envFrom }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  volumeMounts:
  - mountPath: /home/burpsuite
    name: home-burpsuite
  - mountPath: /tmp
    name: tmp
{{- end -}}