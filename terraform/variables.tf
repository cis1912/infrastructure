variable "students" {
  type        = set(string)
  description = "Student pennkeys"
}

variable "image_pull_pat" {
  type        = string
  description = "PAT of GH User to pull gcr images"
}

variable "GF_GH_CLIENT_ID" {
  type        = string
  description = "GitHub Client ID for the CIS188 Grafana OAuth2 Application"
}

variable "GF_GH_CLIENT_SECRET" {
  type        = string
  description = "GitHub Client Secret for the CIS188 Grafana OAuth2 Application"
}
