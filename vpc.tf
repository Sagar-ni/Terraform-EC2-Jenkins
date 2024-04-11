resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.env}-${var.project}-vpc"

  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "${var.env}-${var.project}-igw"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available_1.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.project}-public_subnet_1"

  }
}


resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available_1.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.project}-public_subnet_1"
  }


}



resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "${var.env}-${var.project}-public-rt"
  }
  route {
    gateway_id = aws_internet_gateway.myigw.id
  }
}

resource "aws_route_table_association" "sub-association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id


}

resource "aws_route_table_association" "subnet_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id

}

resource "aws_security_group" "mysg" {
  description = "this security group is for jenkins"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "allowing jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allowing ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-${var.project}-SG"

  }
}
 


resource "aws_instance" "jenkins_server" {
  ami                         = data.aws_ami.amzn_latest.id
  availability_zone           = data.aws_availability_zones.available_1.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.mysg.id]
  key_name                    = "Ganesh"
  associate_public_ip_address = true
  user_data                   = file("jenkins-server-installation-script")
  tags = {
    Name = "${var.env}-${var.project}-jenkins-server"

  }


}


