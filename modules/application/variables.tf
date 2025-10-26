variable "project_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of subnets for instances and load balancer"
  type        = list(string)
}

variable "ssh_security_group_id" {
  description = "ID of SSH security group"
  type        = string
}

variable "private_http_sg_id" {
  description = "ID of private HTTP security group"
  type        = string
}

variable "public_http_sg_id" {
  description = "ID of public HTTP security group"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "desired_capacity" {
  description = "Desired capacity for Auto Scaling Group"
  type        = number
}
