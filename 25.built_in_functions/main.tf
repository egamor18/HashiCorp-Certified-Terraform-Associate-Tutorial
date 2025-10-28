locals {
  maximum = max(var.num_1, var.num_2, var.num_3)
  minimum = min(var.num_1, var.num_2, var.num_3, 44, 20)

  environment_parts = ["dev", "us-east-1", "web"] # join example
  sentence          = "Eric,Gamor,Terraform"      # for split example

  #for split and join
  csv_string = "apple,banana,cherry"
  fruits     = split(",", local.csv_string)
  fruit_list = join(" | ", local.fruits)

  #split join practical example
  env_string = "dev,us-east-1,web"
  env_parts  = split(",", local.env_string)

  #for merge example
  default_tags = {
    Environment = "dev"
    Owner       = "Eric"
  }

  extra_tags = {
    Project = "Terraform Demo"
    Owner   = "Gamor" # Overrides previous "Owner"
  }

  all_tags = merge(local.default_tags, local.extra_tags)

}
/*
resource "aws_s3_bucket" "example" {
  bucket = "terraform-merge-demo-bucket"

  tags = merge(
    {
      Name        = "terraform-merge-demo-bucket"
      Environment = "dev"
    },
    var.tags # allows users to add or override tags
  )
}
*/

output "max_value" {
  value = local.maximum
}

output "min_value" {
  value = local.minimum
}

output "joined_names_space" {
  value = join(" ", var.names) # renamed to avoid duplication
}

output "joined_names_csv" {
  value = join(", ", var.names) # renamed to avoid duplication
}

output "bucket_name" {
  value = join("-", local.environment_parts)
}

output "split_names" {
  value = split(",", local.sentence)
}

output "fruits_list" {
  value = local.fruit_list
}

output "env_parts" {
  value = local.env_parts
}

output "env_tag" {
  value = join("-", local.env_parts)
}

output "merged_tags" {
  value = local.all_tags
}
