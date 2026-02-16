#================= Create vpc ========================#
resource "aws_vpc" "development_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.env_prefix}_vpc"
  }
}

#================= Create subnets ========================#
resource "aws_subnet" "public_development_1" {
  vpc_id                  = aws_vpc.development_vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.env_prefix}_subnet_1"
  }
}

############create igw#################
resource "aws_internet_gateway" "development_igw" {
  vpc_id = aws_vpc.development_vpc.id
  tags = {
    Name : "${var.env_prefix}-igw"
  }
}
############create route table###########
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.development_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.development_igw.id
  }
  tags = {
    Name : "${var.env_prefix}-rtb"
  }
}

resource "aws_route_table_association" "dev_public_association" {
  subnet_id      = aws_subnet.public_development_1.id
  route_table_id = aws_route_table.public_route_table.id
}

######## Create SG ###########
resource "aws_security_group" "dev_sg" {
  name   = "${var.env_prefix}-sg"
  vpc_id = aws_vpc.development_vpc.id


  ingress { # for ssh 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # for http 
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # for http 
    from_port   = 80
    to_port     = 80
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
    Name : "${var.env_prefix}-sg"
  }
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "dev-key" {
  key_name   = "${var.env_prefix}-key"
  public_key = file(var.public_key_location)

}
resource "aws_instance" "dev-server" {
  ami           = data.aws_ami.latest-amazon-linux-image.id
  instance_type = var.instance_type


  subnet_id                   = aws_subnet.public_development_1.id
  vpc_security_group_ids      = [aws_security_group.dev_sg.id]
  availability_zone           = "${var.region}a"
  associate_public_ip_address = true
  user_data                   = file("entry-script.sh")

  tags = {
    Name : "${var.env_prefix}-server"
  }


}

output "ec2_public_ip" {
  value = aws_instance.dev-server.public_ip
}
