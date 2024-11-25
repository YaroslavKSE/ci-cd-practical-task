provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "ec2" {
  source             = "./modules/ec2"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  RocketDexK8s_Frontend_count = var.RocketDexK8s_Frontend_count
  ami_id                      = var.ami_id
  RocketDexK8s_Frontend_type  = var.RocketDexK8s_Frontend_type
  key_name                    = var.key_name
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  sertificat_arn    = var.sertificat_arn
  instance_id       = module.ec2.frontend_instance_id
}