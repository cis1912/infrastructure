variable "pennkey" {
  type        = string
  description = "Pennkey of student"
}

variable "emails" {
  type        = map(any)
  description = "Pennkey to email map"
}
