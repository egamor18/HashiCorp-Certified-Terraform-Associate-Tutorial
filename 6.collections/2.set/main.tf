#demonstrating terraform set
#set is de-duplicator

variable "fruit_set" {
  type    = set(string)
  default = ["apple", "banana", "apple"]
}

output "unique_fruits" {
  value = var.fruit_set
}


# select one fruit
output "one_fruit" {
  value = tolist(var.fruit_set)[1]
}
