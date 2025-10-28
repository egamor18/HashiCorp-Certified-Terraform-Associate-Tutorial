#count n. means that n resources will be created
variable "fruit_list" {
  type    = list(string)
  default = ["apple", "banana", "cherry"]
}

#count.index is used to iterate the  list
resource "local_file" "fruit_file" {
  count    = length(var.fruit_list)
  content  = "This file is about ${var.fruit_list[count.index]}"
  filename = "${path.module}/fruit_${var.fruit_list[count.index]}.txt"
}

#the map gives us 2D inforrmation
output "show_filenames_using_map" {
  value = { for i, f in local_file.fruit_file : i => f.filename }
}


#the map gives us 2D inforrmation
output "show_files_content_using_map" {
  value = { for i, f in local_file.fruit_file : i => f.content }
}

# the list gives 1D info
output "show_filename_using_list" {
  value = [for i in local_file.fruit_file : i.filename]
}
