output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id_a" {
  description = "ID of the private subnet in us-east-1a"
  value       = aws_subnet.private.id
}

output "private_subnet_id_b" {
  description = "ID of the private subnet in us-east-1b"
  value       = aws_subnet.private_b.id
}

output "web_security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.gw.id
}
