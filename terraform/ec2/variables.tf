variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "RocketDexK8s_Frontend_type" {
  description = "RocketDexK8s EC2 instance type"
  type        = string
  default     = "t3.medium"
}


variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "RocketDexK8s_Frontend_count" {
  description = "Number of Elasticsearch nodes"
  type        = number
  default     = 1
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-02db68a01488594c5" # Amazon Linux 2023 AMI
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}