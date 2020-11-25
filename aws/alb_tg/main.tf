resource "aws_lb_target_group_attachment" "alb_tg" {
  count = length(var.ec2_instance_ids)

  target_group_arn = var.alb_target_group_arn
  target_id        = var.ec2_instance_ids[count.index]
  port             = var.target_group_port
}

