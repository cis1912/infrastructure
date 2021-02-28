variable "students" {
  type        = set(string)
  description = "Student pennkeys"
}

variable "image_pull_pat" {
  type        = string
  description = "PAT of GH User to pull gcr images"
}
