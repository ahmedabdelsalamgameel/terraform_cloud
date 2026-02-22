# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "s3_state_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_state_access_policy.arn
}