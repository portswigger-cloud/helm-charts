{{- define "burpsuite.web.containerTemplate" -}}
- image: {{ include "burpsuite.web.image" . }}
  imagePullPolicy: Always
  name: web
  resources:
    requests:
      memory: 1Gi
      cpu: 200m
    limits:
      memory: 1Gi
  ports:
  - name: web-http
    containerPort: 8080
  - name: web-health
    containerPort: 8088
  startupProbe:
    httpGet:
      port: web-health
      path: /health/readiness
    failureThreshold: 60
    periodSeconds: 5
    timeoutSeconds: 2
  livenessProbe:
    httpGet:
      port: web-health
      path: /health/liveness
    failureThreshold: 3
    periodSeconds: 10
    timeoutSeconds: 2
    successThreshold: 1
  readinessProbe:
    httpGet:
      port: web-health
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
        name: web-env
    - secretRef:
        name: web-env
  volumeMounts:
  - mountPath: /home/burpsuite
    name: home-burpsuite
  - mountPath: /tmp
    name: tmp
{{- end -}}