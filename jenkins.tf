resource "aws_instance" "jenkinsserver" {
  ami                         = data.aws_ami.latest_ami.id
  instance_type               = var.instance_type
  key_name                    = "Ganesh"
  subnet_id                   = aws_subnet.public_subnet.id
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  vpc_security_group_ids      = aws_security_group.Mysg.id
  user_data                   = file("jenkins-server-script.sh")
  tags = {
    Name = "${var.Env_prefix}-jenkins_server"
  }

}
