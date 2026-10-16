

variable "environment" {
  type        = string
  description = "Environment name (dev, stage, prod)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}
