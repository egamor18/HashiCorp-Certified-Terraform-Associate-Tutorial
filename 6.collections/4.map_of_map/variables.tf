
#define a map variable

variable "buckets" {
  type = map(any)
  default = {
    dev = {
      bucket1 = "terraform-bucket-gamor-dev-1"
      bucket2 = "terraform-bucket-gamor-dev-2"
    }
    prod = {
      bucket1 = "terraform-bucket-gamor-prod-1"
      bucket2 = "terraform-bucket-gamor-prod-2"
    }
  }
}