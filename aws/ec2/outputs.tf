output "ids" {
  description = "List of IDs of instances"
  value       = aws_instance.ec2_instance.*.id
}

output "arns" {
  description = "List of ARNs of instances"
  value       = aws_instance.ec2_instance.*.arn
}

output "private_ips" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.ec2_instance.*.private_ip
}

output "tags" {
  description = "List of tags of instances"
  value       = aws_instance.ec2_instance.*.tags
}

