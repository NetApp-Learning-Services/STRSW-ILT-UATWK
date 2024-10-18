{{/*
Expand the name of the chart.
*/}}
{{- define "tridentprotect.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tridentprotect.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tridentprotect.labels" -}}
helm.sh/chart: {{ include "tridentprotect.chart" . }}
{{ include "tridentprotect.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tridentprotect.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tridentprotect.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}



{{/*
Create full path to Controller Image
*/}}
{{- define "tridentprotect.fullImage" -}}
{{- if .Values.controller.image.registry }}
  {{- if hasSuffix "/" .Values.controller.image.registry }}
    {{- printf "%s%s" .Values.controller.image.registry .Values.controller.image.repository -}}
  {{- else -}}
    {{- printf "%s/%s" .Values.controller.image.registry .Values.controller.image.repository -}}
  {{- end -}}
{{- else -}}
  {{ .Values.controller.image.repository -}}
{{- end -}}
:{{ .Values.controller.image.tag | default .Chart.AppVersion }}
{{- end -}}
