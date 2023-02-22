variable "students" {
  type        = map(any)
  description = "Map of student pennkeys to github usernames"
}

variable "tas" {
  type        = map(any)
  description = "Map of TA pennkeys to github usernames"
}

variable "instructors" {
  type        = map(any)
  description = "Map of instructor pennkeys to github usernames"
}

variable "image_pull_pat" {
  type        = string
  description = "PAT of GH User to pull gcr images"
}

variable "GF_GH_CLIENT_ID" {
  type        = string
  description = "GitHub Client ID for the CIS1880 Grafana OAuth2 Application"
}

variable "GF_GH_CLIENT_SECRET" {
  type        = string
  description = "GitHub Client Secret for the CIS1880 Grafana OAuth2 Application"
}

variable "emails" {
  type        = map(any)
  description = "Pennkey to email map"
}
