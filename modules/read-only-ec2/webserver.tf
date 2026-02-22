resource "aws_instance" "web_server" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type_in
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name             = var.key_name_in # <<-- Update this with your SSH key
  iam_instance_profile = var.profile_name

  tags = {
    Name = "${var.app_name_in}-instance"
  }
}