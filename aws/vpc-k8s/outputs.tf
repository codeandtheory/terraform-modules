output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "elb_subnet_ids" {
  value = aws_subnet.elb_subnet.*.id
}

output "ec2_subnet_ids" {
  value = aws_subnet.ec2_subnet.*.id
}

output "rds_subnet_ids" {
  value = aws_subnet.elb_subnet.*.id
}

output "rds_subnet_group" {
  value = aws_db_subnet_group.rds_subnet_group.id
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.name
}
