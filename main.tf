terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
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
  
  private_subnet_id     = module.networking.private_subnet_id
  db_username          = var.db_username
  db_password          = var.db_password
  db_security_group_id = module.networking.db_security_group_id
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
