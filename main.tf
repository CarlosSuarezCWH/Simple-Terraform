terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = ""
    key            = "terraform.tfstate"
    region         = ""
    encrypt        = true
    # dynamodb_table = "" # Descomenta si usas DynamoDB para locking
  }
}

provider "aws" {
  region = var.aws_region
}

# Networking module
module "networking" {
  source = "./modules/networking"
}

# Database module
module "database" {
  source = "./modules/database"
  
  private_subnet_ids    = [module.networking.private_subnet_id_a, module.networking.private_subnet_id_b]
  db_username           = var.db_username
  db_password           = var.db_password
  db_security_group_id  = module.networking.db_security_group_id
}

# Compute module
module "compute" {
  source = "./modules/compute"
  
  public_subnet_id      = module.networking.public_subnet_id
  web_security_group_id = module.networking.web_security_group_id
  key_name             = var.key_name
  db_endpoint          = module.database.db_endpoint
  db_name              = module.database.db_name
  db_username          = var.db_username
  db_password          = var.db_password
}

# Outputs
output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = module.database.db_endpoint
}

output "web_server_ip" {
  description = "The public IP of the web server"
  value       = module.compute.web_server_public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.networking.vpc_id
}

output "application_url" {
  description = "URL of the web application"
  value       = "http://${module.compute.web_server_public_ip}:5000"
}

output "database_name" {
  description = "The name of the database"
  value       = module.database.db_name
}
