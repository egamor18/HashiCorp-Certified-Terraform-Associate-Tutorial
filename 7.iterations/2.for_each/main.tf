variable "fruit_set" {
  type    = set(string)
  default = ["apple", "banana", "cherry"]
}

resource "local_file" "fruit_file" {
  for_each = var.fruit_set
  content  = "This file is about ${each.key}"
  filename = "${path.module}/fruit_${each.key}.txt"
}

output "created_files" {
  value = [for k, v in local_file.fruit_file : v.filename]
}

output "output_filename_using_map" {
  value = { for idx ,f in local_file.fruit_file  : idx => f.filename   }
}


output "output_file_content_using_map" {
  value = { for idx ,f in local_file.fruit_file  : idx => f.content   }

}