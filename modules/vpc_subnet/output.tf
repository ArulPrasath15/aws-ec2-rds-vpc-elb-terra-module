output "vpc_id" {
    value=aws_vpc.vpc.id
}

output "private_subnet_ids" {
  value =  aws_subnet.private_subnet.*.id
}

output "public_subnet_ids" {
  value =  aws_subnet.public_subnet.*.id
}

output "public_subnets_cidr" {
  value = aws_subnet.public_subnet.*.cidr_block
}

