# Create the IAM Policy
resource "aws_iam_policy" "s3_state_access_policy" {
  name        = "EC2-S3-State-Read-Policy"
  description = "Policy for EC2 to read the Terraform state file."
  policy      = data.aws_iam_policy_document.s3_state_access_doc.json
}