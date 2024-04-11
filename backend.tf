terraform {
  backend "s3" {
    bucket = "3-bucket-vpc-ec2-jenkins-project"
    region = "ap-south-1"
    key    = "new/terraform.tfstatefile"
  }
}

