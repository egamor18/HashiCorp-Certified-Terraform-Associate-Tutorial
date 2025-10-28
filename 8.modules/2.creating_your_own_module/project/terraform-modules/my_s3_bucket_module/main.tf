#
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

#what does merge() do?
  tags = merge(
    {
      Name = var.bucket_name
    },
    var.tags
  )
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  # whether versioning should be enabled or not
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}
