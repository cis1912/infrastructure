variable "pennkey" {
  type        = string
  description = "Pennkey of student"
}

variable "hw" {
  type        = string
  description = "Homework to create repo of (Ex. hw0)."
}

variable "team-id" {
  type        = string
  description = "ID of the team the student belongs to."
}

variable "bot-team-id" {
  type        = string
  description = "ID of the CIS 1912 bot team."
}

variable "published" {
  type        = bool
  description = "Should this homework be published?"
}
