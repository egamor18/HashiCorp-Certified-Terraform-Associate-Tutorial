 bucket         = "terraform-s3-backend-authentication-demo-gamor"
 key            = "partial_backend_file/terraform/state/terraform.tfstate"
 dynamodb_table = "terraform-locks" # DynamoDB table used for state locking. This enables state locking
 encrypt        = true              # Optional: encrypt state at rest