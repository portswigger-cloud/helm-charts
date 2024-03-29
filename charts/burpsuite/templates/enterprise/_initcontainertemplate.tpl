{{- define "burpsuite.enterprise.initContainerTemplates" -}}
- name: init-burp-download
  image: {{ include "burpsuite.enterprise.image" . }}
  envFrom:
    - configMapRef:
        name: enterprise-env
  command:
    - 'sh'
    - '-c'
    - |
      set -eux

      mkdir -p /tmp/keystores
      mkdir -p /tmp/prefs
      mkdir -p /tmp/burp
      mkdir -p /tmp/logs
      mkdir -p /tmp/data/tmp

      cp -rn /home/burpsuite/burp/* /tmp/burp/ || echo Unable to copy Scanner JAR to volume mount
  volumeMounts:
    - name: home-burpsuite
      mountPath: /tmp
  securityContext:
    capabilities:
      drop:
      - ALL
    readOnlyRootFilesystem: true
    allowPrivilegeEscalation: false
    runAsNonRoot: true
- name: init-enterprise-server-keystore
  image: {{ include "burpsuite.enterprise.image" . }}
  resources:
    limits:
      cpu:
      memory:
    requests:
      cpu:
      memory:
  envFrom:
    - configMapRef:
        name: enterprise-env
    - secretRef:
        name: enterprise-env
  command:
    - 'sh'
    - '-c'
    - |
      set -eux

      /usr/local/burpsuite_enterprise/bin/createKeystore es $BSEE_HTTPS_KEYSTORE_LOCATION $BSEE_HTTPS_KEYSTORE_PASSWORD
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