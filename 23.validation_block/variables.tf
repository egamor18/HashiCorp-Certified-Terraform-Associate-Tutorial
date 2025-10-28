# the variable and its name
variable "region" {
  type = string

  #validation block
  validation {
    condition     = contains(["us-east-1", "us-east-2", "eu-north-1"], lower(var.region))
    error_message = "You must use an approved region: us-east-1, us-east-2, eu-north-1"
  }
}
