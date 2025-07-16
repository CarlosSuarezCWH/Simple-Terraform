output "web_server_public_ip" {
  description = "Public IP of the web server"
  value       = aws_eip.web.public_ip
}

output "web_server_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web.id
} 