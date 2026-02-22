terraform {
  backend "s3" {
    bucket       = "ahmed-abdelsalam-demo-bk"
    key          = "terraform/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
  }
}