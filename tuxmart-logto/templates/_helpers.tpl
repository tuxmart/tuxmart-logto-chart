{{/* Expand the name of the chart. */}}
{{- define "tuxmart-logto.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create a default fully qualified app name. */}}
{{- define "tuxmart-logto.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "tuxmart-logto.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "tuxmart-logto.labels" -}}
helm.sh/chart: {{ include "tuxmart-logto.chart" . }}
{{ include "tuxmart-logto.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Selector labels */}}
{{- define "tuxmart-logto.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tuxmart-logto.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Get service account name */}}
{{- define "tuxmart-logto.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "tuxmart-logto.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/* Database connection URL generator */}}
{{- define "tuxmart-logto.databaseUrl" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- printf "postgresql://%s:%s@%s:%d/%s" .Values.externalDatabase.username .Values.externalDatabase.password .Values.externalDatabase.host .Values.externalDatabase.port .Values.externalDatabase.database -}}
{{- if .Values.externalDatabase.ssl -}}
?ssl=true&sslmode={{ .Values.externalDatabase.sslMode }}
{{- end -}}
{{- else if .Values.postgresql.enabled -}}
{{- printf "postgresql://%s:%s@%s-postgresql:%d/%s" .Values.postgresql.auth.username .Values.postgresql.auth.password (include "tuxmart-logto.fullname" .) .Values.postgresql.service.port .Values.postgresql.auth.database -}}
{{- else -}}
{{- fail "Either externalDatabase or postgresql must be enabled" -}}
{{- end -}}
{{- end -}}

{{/* Get database host */}}
{{- define "tuxmart-logto.databaseHost" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- .Values.externalDatabase.host -}}
{{- else if .Values.postgresql.enabled -}}
{{- printf "%s-postgresql" (include "tuxmart-logto.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/* Get database port */}}
{{- define "tuxmart-logto.databasePort" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- .Values.externalDatabase.port -}}
{{- else if .Values.postgresql.enabled -}}
{{- .Values.postgresql.service.port -}}
{{- end -}}
{{- end -}}

{{/* Get database username */}}
{{- define "tuxmart-logto.databaseUsername" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- .Values.externalDatabase.username -}}
{{- else if .Values.postgresql.enabled -}}
{{- .Values.postgresql.auth.username -}}
{{- end -}}
{{- end -}}

{{/* Get database name */}}
{{- define "tuxmart-logto.databaseName" -}}
{{- if .Values.externalDatabase.enabled -}}
{{- .Values.externalDatabase.database -}}
{{- else if .Values.postgresql.enabled -}}
{{- .Values.postgresql.auth.database -}}
{{- end -}}
{{- end -}}

{{/* Get Logto endpoint */}}
{{- define "tuxmart-logto.endpoint" -}}
{{- if .Values.logto.endpoint -}}
{{- .Values.logto.endpoint -}}
{{- else -}}
{{- printf "http://%s:%d" (include "tuxmart-logto.fullname" .) .Values.service.port -}}
{{- end -}}
{{- end -}}

{{/* Get Admin endpoint */}}
{{- define "tuxmart-logto.adminEndpoint" -}}
{{- if .Values.logto.adminEndpoint -}}
{{- .Values.logto.adminEndpoint -}}
{{- else -}}
{{- printf "http://%s:%d/admin" (include "tuxmart-logto.fullname" .) .Values.service.port -}}
{{- end -}}
{{- end -}}
