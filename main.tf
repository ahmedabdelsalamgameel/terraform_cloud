module "vpc" {
  source         = "./modules/network"
  vpc_cidr_in    = var.vpc_cidr_out
  subnet_cidr_in = var.subnet_cidr_out
  app_name_in    = var.app_name_out
}

module "security_group" {
  source      = "./modules/security_group"
  vpc_id      = module.vpc.vpc_id
  app_name_in = var.app_name_out
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type_in  = var.instance_type_out
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  app_name_in       = var.app_name_out
}