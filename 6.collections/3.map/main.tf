#demonstration of map

variable "fruit_colors" {
  type = map(string)
  default = {
    apple  = "red"
    banana = "yellow"
    cherry = "dark red"
  }
}

#outputting only banana
output "banana_color" {
  value = var.fruit_colors["banana"]
}

#output all colours
output "all_fruit_colors" {
  value = { for i, c in var.fruit_colors: i=>c }
} 