terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "terraform_remote_state" "theo-commits-bucket" {
  backend = "s3"
  config = {
    bucket = "theo-commits-bucket"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}


# Specify Provider
provider "aws" {
  region = "us-east-2"
}

# Refer to state stored in S3 bucket for the given region 
terraform {
  backend "s3" {
    bucket = "theo-commits-bucket"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_instance" "webserver" {
  ami                  = "ami-0adc4758ea76442e2" # Amazon Linux 2 ECS Optimized AMI
  instance_type        = "t2.micro"
  key_name             = "vault"
  tags = {
    Name = "webserver"
  }
}