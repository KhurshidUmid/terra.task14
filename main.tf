module "network" {
  source = "./modules/network"

  project_prefix      = var.project_prefix
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "network_security" {
  source = "./modules/network_security"

  project_prefix   = var.project_prefix
  vpc_id           = module.network.vpc_id
  allowed_ip_range = var.allowed_ip_range
}

module "application" {
  source = "./modules/application"

  project_prefix        = var.project_prefix
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.public_subnet_ids
  ssh_security_group_id = module.network_security.ssh_sg_id
  private_http_sg_id    = module.network_security.private_http_sg_id
  public_http_sg_id     = module.network_security.public_http_sg_id
  instance_type         = var.instance_type
  desired_capacity      = var.desired_capacity
}
