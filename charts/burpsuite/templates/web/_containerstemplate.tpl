{{- define "burpsuite.web.containerTemplate" -}}
- image: {{ include "burpsuite.web.image" . }}
  imagePullPolicy: Always
  name: web
  resources:
    requests:
      memory: {{ .Values.web.resources.memory }}
      cpu: {{ .Values.web.resources.cpu }}
      ephemeral-storage: 1.5Gi
    limits:
      memory: {{ .Values.web.resources.memory }}
  ports:
  - name: web-http
    containerPort: 8080
  - name: web-health
    containerPort: 8088
  - name: web-scim
    containerPort: 8089
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
    {{- with .Values.web.envFrom }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  env:
    - name: KUBERNETES_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: KUBERNETES_POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: KUBERNETES_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    - name: KUBERNETES_POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
  {{- with .Values.web.env }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
  - mountPath: /home/burpsuite
    name: home-burpsuite
  - mountPath: /tmp
    name: tmp
{{- end -}}