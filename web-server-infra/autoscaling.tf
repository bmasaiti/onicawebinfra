
resource "aws_autoscaling_group" "autoscaling-grp" {
  name                      = "webserver-autoscaling-grp"
  #vpc_zone_identifier       = ["${aws_subnet.PRIVATE_SUB_BUDWELL_LAB_0.id}", "${aws_subnet.PUBLIC_SUB_BUDWELL_LAB_0.id}"]
  vpc_zone_identifier       = ["${aws_subnet.PRIVATE_SUB_BUDWELL_LAB_0.id}","${aws_subnet.PRIVATE_SUB_BUDWELL_LAB_1.id}"]
  desired_capacity          = var.DESIRED_INSTANCES
  min_size                  = var.MIN_INSTANCES
  max_size                  = var.MAX_INSTANCES
  health_check_grace_period = 300
  #health_check_type = "EC2" #used when checking directly on instances
  health_check_type = "ELB"
  force_delete      = "true"
  load_balancers    = ["${aws_elb.webserver-elb.name}"]
  launch_template {
    id = aws_launch_template.webserver_launch_template.id

  }

}

resource "aws_autoscaling_policy" "cpu-autoscaling-policy" {
  name                   = "cpu-autoscaling-polic"
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling-grp.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
  alarm_name          = "cpu-alarm"
  alarm_description   = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "aws_autoscaling_group" = "${aws_autoscaling_group.autoscaling-grp.name}"
  }

  actions_enabled = "true"
  alarm_actions   = ["${aws_autoscaling_policy.cpu-autoscaling-policy.arn}"]

}



resource "aws_sns_topic" "cpu-sns-email-alert" {
  name         = "sg-cpu-sns"
  display_name = "ASG SNS TOPIC"
} #email subscription to be included later because nt supported in traffic_routing_method

