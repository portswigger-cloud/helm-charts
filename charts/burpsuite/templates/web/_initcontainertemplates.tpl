{{- define "burpsuite.web.initContainerTemplates" -}}
- name: init-web-server-keystore
  image: {{ include "burpsuite.web.image" . }}
  resources:
    limits:
      cpu:
      memory:
    requests:
      cpu:
      memory:
  envFrom:
    - configMapRef:
        name: web-env
    - secretRef:
        name: web-env
  command:
    - 'sh'
    - '-c'
    - |
      set -eux

      mkdir -p /home/burpsuite/keystores
      mkdir -p /home/burpsuite/logs
      mkdir -p /home/burpsuite/burp

      /usr/local/burpsuite_enterprise/bin/createKeystore webserver $BSEE_CLIENT_KEYSTORE_LOCATION $BSEE_CLIENT_KEYSTORE_PASSWORD
  volumeMounts:
    - name: home-burpsuite
      mountPath: /home/burpsuite
  securityContext:
    capabilities:
      drop:
      - ALL
    readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
    runAsNonRoot: true
{{- end -}}