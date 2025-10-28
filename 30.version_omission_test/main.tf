

module "consul" {
  source  = "hashicorp/consul/aws"
  #version = "0.9.2"
  servers = 3
}