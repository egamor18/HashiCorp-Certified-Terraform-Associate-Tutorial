#this demonstrate lists
# a simple collection of items that are accessed by index.
# because it referenced by index, the items doesnt have be unique

variable "fruit_list" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

# output the list contents

output "second_fruit" {
  # to display only one item, we use the index
  value = var.fruit_list[1] # → "banana"

}

output "all_fruit" {

  #to display the whole list
  value = var.fruit_list

}

#outputing the list using count
output "looping_over_fruit" {
  #Note: count is not supported in output
  #count = length(var.fruit_list)
  #value= [var.fruit_list[count.index]]

  #value = { for idx, fruit in var.fruit_list : idx => fruit }
  value = { for i, f in var.fruit_list : i => f }
}

