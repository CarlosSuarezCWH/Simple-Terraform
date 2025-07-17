variable "private_subnet_ids" {
  description = "IDs of the private subnets"
  type        = list(string)
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_security_group_id" {
  description = "ID of the database security group"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "sportsstore"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t2.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 10
}
