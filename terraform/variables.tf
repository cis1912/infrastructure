variable "students" {
  type        = map(any)
  description = "Map of student pennkeys to github usernames"
  default = {
    "anniwang" = "anniewang408"
    "bjin1618" = "belindajin"
    "jasonhom" = "homjason"
    "yuanb"    = "yuanb01"
    "orestis"  = "Orescout"
    "lohpaul9" = "lohpaul9"
    "hojack"   = "jhourigan8"
    "edgoze"   = "Edgoze"
    "arushiag" = "arushiag1"
    "minseokk" = "minskim0327"
    "mafallon" = "mattf196"
    "karlei"   = "karleikongsiri"
    "kevlamb"  = "kev-lamb"
    "choxner"  = "choxner"
    "skcheung" = "skylercheung"
  }
}

variable "tas" {
  type        = map(any)
  description = "Map of TA pennkeys to github usernames"
  default = {
    "joyliu" = "joyliu-q"
  }
}

variable "instructors" {
  type        = map(any)
  description = "Map of instructor pennkeys to github usernames"
  default = {
    "cphalen" = "cphalen"
    "grohan"  = "rohangpta"
  }
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
