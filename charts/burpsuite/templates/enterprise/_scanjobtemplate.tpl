{{- define "burpsuite.enterprise.scanJobtemplate" -}}
{{- if .Values.enterprise.scanJobTemplate -}}
{{ .Values.enterprise.scanJobTemplate }}
{{- else -}}
apiVersion: batch/v1
kind: Job
metadata:
  labels:
    app.kubernetes.io/component: scanner
    {{ include "burpsuite.labels" . | nindent 4 }}
spec:
  backoffLimit: 0
  template:
    metadata:
      labels:
        app.kubernetes.io/component: scanner
        {{ include "burpsuite.labels" . | nindent 8 }}
      annotations:
        cluster-autoscaler.kubernetes.io/safe-to-evict: "false"
    spec:
      containers:
        - env:
            - name: BSEE_EPHEMERAL_AGENT_LICENSING_MAX_RETRIES
              value: "5"
            - name: BSEE_EPHEMERAL_AGENT_LICENSING_RETRY_DELAY
              value: "120"
            - name: BSEE_LOGS_DIRECTORY
              value: /home/burpsuite/logs
            - name: BSEE_BURP_DOWNLOAD_PATH
              value: /home/burpsuite/burp
            - name: EPHEMERAL_AGENT_OPTS
              value: -Xms128m -Xmx512m
            - name: BSEE_BURP_JAVA_OPTS
              value: -Xms1g -XX:MaxRAMPercentage=75
            - name: BSEE_EPHEMERAL_SETTINGS_PATH
              value: /home/burpsuite/secrets/scanInitiationRequest.json
          image: {{ include "burpsuite.agent.image" . }}
          imagePullPolicy: Always
          resources:
            limits:
              cpu: 4
              memory: 4Gi
            requests:
              cpu: 4
              memory: 4Gi
          volumeMounts:
            - mountPath: /home/burpsuite
              name: home-burpsuite
      restartPolicy: Never
      terminationGracePeriodSeconds: 30
      volumes:
        - name: home-burpsuite
          emptyDir:
            sizeLimit: 2Gi
{{- end -}}
{{- end -}}