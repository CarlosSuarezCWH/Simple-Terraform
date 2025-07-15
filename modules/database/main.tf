resource "aws_db_subnet_group" "default" {
  name       = "main-db-subnet-group"
  subnet_ids = [var.private_subnet_id]

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "sportsstore"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.db_security_group_id]
}

resource "null_resource" "db_setup" {
  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.default.address} -u ${var.db_username} -p${var.db_password} ${aws_db_instance.default.name} < ${path.module}/../../scripts/database_init.sql"
  }

  depends_on = [aws_db_instance.default]
}
