# Create the Instance Profile
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "EC2-S3-State-Reader-Profile"
  role = aws_iam_role.ec2_s3_role.name
}