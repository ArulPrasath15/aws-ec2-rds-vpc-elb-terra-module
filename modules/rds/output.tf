output "mysql_endpoint_dns" {
  value = aws_db_instance.mysql.address
}
