resource "aws_db_subnet_group" "default" {
  name       = "main-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "sportsstore"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.db_security_group_id]
}
