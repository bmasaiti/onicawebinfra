

resource "aws_elb" "webserver-elb" {
  internal = false
  #load_balancer_type = "application"
  subnets         = ["${aws_subnet.PUBLIC_SUB_BUDWELL_LAB_0.id}", "${aws_subnet.PUBLIC_SUB_BUDWELL_LAB_1.id}"]
  security_groups = ["${aws_security_group.elb-security-group.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }


  #instances =["${}"]
  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  tags = {
    Name = "webserver-elb"
  }
}
