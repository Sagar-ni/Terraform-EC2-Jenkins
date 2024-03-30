resource "aws_vpc" "myvpc" {
  cidr_block = var.myvpc_cidr
  tags = {
    Name = "${var.Env_prefix}-vpc"
  }

}


##### creating subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       =var.avail_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.Env_prefix}-subnet"

  }

}

resource "aws_internet_gateway" "myIGw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "${var.Env_prefix}-IGW"
  }
}

resource "aws_route_table" "route_table_1" {
  vpc_id = aws_vpc.myvpc.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGw.id
  }

  tags = {
    Name = "${var.Env_prefix}-RT-1"
  }
}

resource "route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.route_table_1.id
  subnet_id      = aws_subnet.Public_subnet.id

}

resource "aws_security_group" "Mysg" {
  vpc_id      = aws_vpc.myvpc.id
  description = "craeting this security for jenkins"

  ingress {
    description = "allowing to access port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "allowing  access to port 8080 "
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.Env_prefix}-SG"

  }
}
