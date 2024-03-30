data "aws_availability_zones" "available_1" {
  state = "available"

}

data "aws_ami" "latest_ami" {
  most_recent = "true"
  owners      = ["amzon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
 filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
