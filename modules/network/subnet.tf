resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_in
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.app_name_in}-subnet"
  }
}
