# Create Nginx server with Terrraform
## Getting Started:

1. `terraform init`
2. `terraform apply`
3. `curl "http://$(terraform output -raw instance_public_ip)"`
