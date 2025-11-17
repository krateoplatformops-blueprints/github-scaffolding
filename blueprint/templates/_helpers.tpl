{{/*
Expand the name of the chart.
*/}}
{{- define "github-scaffolding.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "github-scaffolding.fullname" -}}
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
{{- define "github-scaffolding.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "github-scaffolding.labels" -}}
helm.sh/chart: {{ include "github-scaffolding.chart" . }}
{{ include "github-scaffolding.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "github-scaffolding.selectorLabels" -}}
app.kubernetes.io/name: {{ include "github-scaffolding.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "github-scaffolding.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "github-scaffolding.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate a unique list of toRepo objects (without the path field)
*/}}
{{- define "github-scaffolding.toRepoUnique" -}}
{{- $compare := list }}
{{- $out := list }}
{{- with .Values.git }}
{{- range $j, $d := . }}
{{- $clean := omit $d.toRepo "path" "branch" }}
{{- if not (has $clean $compare) }}
{{- $compare = append $out $clean }}
{{- $out = append $out $d }}
{{- end }}
{{- end }}
{{- end }}
{{- toYaml $out }}
{{- end }}

{{/*
Compose toRepo URL using a repo object ($d)
*/}}
{{- define "github-scaffolding.toRepoUrl" -}}
{{- $d := . -}}
{{- printf "%s/%s/%s" $d.toRepo.scmUrl $d.toRepo.org $d.toRepo.name }}
{{- end }}

{{/*
Compose fromRepo URL using a repo object ($d)
*/}}
{{- define "github-scaffolding.fromRepoUrl" -}}
{{- $d := . -}}
{{- printf "%s/%s/%s" $d.fromRepo.scmUrl $d.fromRepo.org $d.fromRepo.name }}
{{- end }}