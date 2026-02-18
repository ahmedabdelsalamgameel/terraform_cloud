#!/bin/bash

set -e

echo "🚀 Initialsing the Terraform Config"
terraform init

echo "✅ Creating and applying Dev Env"
terraform workspace new dev
terraform workspace select dev
terraform plan
terraform apply -auto-approve

echo "✅ Creating and applying Stage Env"
terraform workspace new stage
terraform workspace select stage
terraform plan
terraform apply --auto-approve

echo "✅ Creating and applying Prod Env"
terraform workspace new prod
terraform workspace select prod
terraform plan
terraform apply --auto-approve