variable "fruit_list" {
  default = ["apple", "banana", "kiwi", "cherry"]
}

/*
locals {
  long_fruits = [for fruit in var.fruit_list : fruit if length(fruit) > 5]
}
*/

locals {
  long_fruits = [for fruit in var.fruit_list : fruit]
}
/*
the above is similar to array initialization:
long_fruits[0]="apple"
long_fruits[1]="banana"
long_fruits[2]="kiwi"
*/

resource "local_file" "long_fruit_file" {
  # to use for_each, we must convert the list to a set.
  # then we use each.key to get the value.

  for_each = toset(local.long_fruits)
  content  = "This fruit has a long name: ${each.key}"
  filename = "${path.module}/long_${each.key}.txt"
}

output "long_fruits" {
  value = local.long_fruits
}
