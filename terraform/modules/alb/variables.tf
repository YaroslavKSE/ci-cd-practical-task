variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of public subnets"
  type        = list(string)
}

variable "certificate_arn" {
  description = "The arn of pregenerated SSL/TLS certificat"
  type        = string
}

variable "instance_id" {
  description = "ID of the EC2 instance to attach to the target group"
  type        = string
}