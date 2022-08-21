# Nginx, AWS EC2, Terrraform
Deploys and Nginx server on AWS EC2 with Terraform

## Getting Started:

1. `terraform init`
2. `terraform apply`
3. `curl "http://$(terraform output -raw instance_public_ip)"`
