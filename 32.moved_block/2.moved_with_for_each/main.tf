#when refactoring, the old block is not included
# you can use the command: terraform console
# so that you can interactively explore the expresssions
#eg. local.files["small"].content

/*
resource "local_file" "example" {
  content  = "Hello, Terraform!"
  filename = "${path.module}/hello.txt"
}
*/


locals {
  files = {
    small = { content = "This is the small file" }
    big   = { content = "This is the big file" }
  }
}

#each.key will give you: small and big
#each.value will give you { content = "blabla blabla"}

resource "local_file" "example" {
  for_each = local.files   
  content  = each.value.content
  filename = "${path.module}/${each.key}.txt"
}

moved {
  from = local_file.example
  to   = local_file.example["small"]  # what is the output of this?
}


output "my_variable" {
  value = local.files["small"].content
}

