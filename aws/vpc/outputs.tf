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
  value = "${ var.make_rds_subnets ? aws_db_subnet_group.rds_subnet_group[0].id : "" }"
}

output "rds_subnet_group_name" {
  value = "${ var.make_rds_subnets ? aws_db_subnet_group.rds_subnet_group[0].name : "" }"
}
