variable "num_1" {
  type        = number
  description = "Numbers for function labs"
  default     = 88
}
variable "num_2" {
  type        = number
  description = "Numbers for function labs"
  default     = 73
}
variable "num_3" {
  type        = number
  description = "Numbers for function labs"
  default     = 52
}

variable "names" {
  type    = list(string)
  default = ["Eric", "Gamor", "Terraform"]
}

