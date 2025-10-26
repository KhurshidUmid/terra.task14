aws_region          = "us-east-1"
project_prefix      = "cmtr-xv69vdlr"
vpc_cidr            = "10.10.0.0/16"
public_subnet_cidrs = ["10.10.1.0/24", "10.10.3.0/24", "10.10.5.0/24"]
availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
allowed_ip_range    = ["18.153.146.156/32", "195.158.28.86/32"]
instance_type       = "t3.micro"
desired_capacity    = 2
