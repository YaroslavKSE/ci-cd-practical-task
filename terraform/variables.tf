variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-north-1a"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-02db68a01488594c5" # Amazon Linux 2023 AMI
}

variable "sertificat_arn" {
  description = "The arn of pregenerated SSL/TLS certificat"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "RocketDexK8s_Frontend_type" {
  description = "RocketDexK8s EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "RocketDexK8s_Frontend_count" {
  description = "Number of frontend instances to create"
  type        = number
  default     = 1
}