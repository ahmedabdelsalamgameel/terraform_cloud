# IAM Policy Document for S3 State Access
data "aws_iam_policy_document" "s3_state_access_doc" {
  statement {
    sid    = "AllowListAndLocation"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["arn:aws:s3:::ahmed-abdelsalam-demo-bk"]
  }

  statement {
    sid    = "AllowReadStateFile"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::ahmed-abdelsalam-demo-bk/terraform/terraform.tfstate"]
  }
}