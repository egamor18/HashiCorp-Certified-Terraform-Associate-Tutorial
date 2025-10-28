
#define a map variable

variable "buckets" {
  type = map(string)
  default = {
    bucket1 = "terraform-bucket-gamor-1"
    bucket2 = "terraform-bucket-gamor-2"
  }
}