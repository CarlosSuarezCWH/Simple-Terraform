output "db_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.default.endpoint
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.default.name
}

output "db_port" {
  description = "Database port"
  value       = aws_db_instance.default.port
}

output "db_identifier" {
  description = "Database identifier"
  value       = aws_db_instance.default.id
}
