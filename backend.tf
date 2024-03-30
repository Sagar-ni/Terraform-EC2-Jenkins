terraform {
  backend "s3" {
    bucket = "my-bucket-for-jenkins-123"
    region = "us-east-1"
    key    = "new/terraform.tfstate"
  }
}