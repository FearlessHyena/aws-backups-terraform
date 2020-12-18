# Template File for saving the TF State to S3 and enabling state locking
## You can use this file to save your state to S3
## Uncomment the sections you need and please modify the attributes before using!

// Uncomment the following resource block to enable saving state to S3
// Remember to replace the Bucket ID and other attributes as needed!
/*
terraform {
  backend "s3" {
    bucket         = "<REPLACE_WITH_YOUR_BUCKET_NAME>"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
*/

// Uncomment the following resource block to enable state locking
// Remember to replace the attributes as needed!
/*
resource "aws_dynamodb_table" "terraform-state-lock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
*/