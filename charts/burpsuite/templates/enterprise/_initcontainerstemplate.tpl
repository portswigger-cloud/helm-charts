{{- define "burpsuite.enterprise.initContainerTemplates" -}}
- name: init-burp-download
  image: {{ include "burpsuite.enterprise.image" . }}
  resources:
    requests:
      cpu:
      memory:
    limits:
      cpu:
      memory:
  envFrom:
    - configMapRef:
        name: {{ include "burpsuite.enterprise.fullname" . }}
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

      cp -n /home/burpsuite/burp/burpsuite_pro_v*.jar /tmp/burp/ || echo Unable to copy Scanner JAR to volume mount
  volumeMounts:
    - name: home-burpsuite
      mountPath: /tmp
  securityContext:
    {{- toYaml .Values.enterprise.securityContext | nindent 4 }}
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
        name: {{ include "burpsuite.enterprise.fullname" . }}
    - secretRef:
        name: {{ include "burpsuite.enterprise.fullname" . }}
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
    {{- toYaml .Values.enterprise.securityContext | nindent 4 }}
{{- end -}}