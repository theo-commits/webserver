# Create an S3 bucket for storing state 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "tf_state" {
  # Unique bucket name 
  bucket = "theo-commits-bucket"

  # Prevent accidental deletion of tf state
  lifecycle {
    prevent_destroy = true
  }

  # Enable Versioning to track history 
  versioning {
    enabled = true
  }

  # Enable Encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Create DynamoDB Table for state locking

resource "aws_dynamodb_table" "db_for_tf_locks" {
  name           = "db_for_tf_locks"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}