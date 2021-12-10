#DB Subnet Group with two Private Subnet
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.owner}-db-subnet-group"
  subnet_ids  = var.private_subnet_ids #
  description = "DB Subnet Groups"
  tags = {
    Name = "${var.owner}-db-subnet-group"
    Createdby="${var.ownermail}"
    Environmnet="${var.env}"
  }
}

#SG for DB
resource "aws_security_group" "db_sg" {
  name   = "${var.owner}-db-sg"
  vpc_id = var.vpc_id      #
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.public_subnets_cidr # 
  }
  tags = {
    Name = "${var.owner}-db-sg"
    Createdby="${var.ownermail}"
    Environmnet="${var.env}"
  }
}

#RDS Instance
resource "aws_db_instance" "mysql" {
  identifier             = "${var.owner}-db"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  name                   = "${var.owner}DB"
  username               = "root"
  password               = "rootroot"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name  
  vpc_security_group_ids = [aws_security_group.db_sg.id]   
  tags = {
    Name = "${var.owner}-db-sg"
    Createdby="${var.ownermail}"
    Environmnet="${var.env}"
  }
}