

output "bucket_id" {
  description = "The ID of the bucket"
  value       = aws_s3_bucket.my_bucket.id  #Note: nothing like module.blablala. But rather the resource.blabla
}


output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.my_bucket.arn
}
