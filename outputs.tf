output "load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = module.application.load_balancer_dns_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.network.public_subnet_ids
}
