{{/*
Expand the name of the chart.
*/}}
{{- define "blog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "blog.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "blog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "blog.labels" -}}
helm.sh/chart: {{ include "blog.chart" . }}
{{ include "blog.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "blog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "blog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "blog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "blog.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "postgresql.fullname" -}}
{{- printf "%s-%s" .Release.Name "postgresql" | trunc  63 | trimSuffix "-" -}}
{{- end -}}

{{- define "postgresql.username" -}}
blog
{{- end -}}

{{- define "postgresql.env" -}}
{{- if .Values.postgresql.bitnami.enabled -}}
- name: DATABASE_HOST
  value: {{ template "postgresql.fullname" . }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "postgresql.fullname" . }}
      key: postgres-password
{{- else if .Values.postgresql.operator.enabled }}
- name: DATABASE_HOST
  value: {{ template "postgresql.fullname" . }}
- name: POSTGRES_USERNAME
  value: {{ template "postgresql.username" . }}
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ template "postgresql.username" . }}.{{ template "postgresql.fullname" . }}.credentials.postgresql.acid.zalan.do
      key: password
{{- end -}}
{{- end -}}
