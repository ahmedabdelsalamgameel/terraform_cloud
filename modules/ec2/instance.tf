resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type_in
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              apt get update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2
              cat > /var/www/html/index.html <<EOT
              ${file("${path.module}/index.html")}
              EOT
              EOF


  tags = {
    Name = "${var.app_name_in}-instance"
  }
}