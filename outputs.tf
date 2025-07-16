output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.networking.private_subnet_id
}

output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = module.compute.web_server_public_ip
}

output "database_endpoint" {
  description = "Database endpoint"
  value       = module.database.db_endpoint
}

output "application_url" {
  description = "URL of the web application"
  value       = "http://${module.compute.web_server_public_ip}"
}
