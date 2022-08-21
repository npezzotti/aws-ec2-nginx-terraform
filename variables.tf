variable "project-name" {
  default = "tf-nginx"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "instance_name" {
  description = "Value of the Name of the EC2 instance"
  type        = string
  default     = "NginxServer"
}

variable "ami" {
  description = "AMI"
  type        = string
  default     = "ami-090fa75af13c156b4"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

