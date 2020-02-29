# To create  S3 bucket 

provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
}


resource "aws_s3_bucket" "tfb01" {
  bucket = "muni-tf-bucket-01"
  #acl    = "private"
  acl    = "public-read"
  
  versioning {
    enabled = true
  }

  tags = {
    Name        = "Muni Tf Bucket 01"
    Environment = "Public Bucket for Demo"
  }
}


output "S3 Bucket id:" {
     
    value = "${aws_s3_bucket.tfb01.id}"
}

