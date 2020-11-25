variable "alb_target_group_arn" {
  description = "What target group are we adding instances to?"
}

variable "ec2_instance_ids" {
  description = "Need a list of instances to add to the target group"
}

variable "target_group_port" {
  description = "What port is the target group receiving traffic on?"
}
