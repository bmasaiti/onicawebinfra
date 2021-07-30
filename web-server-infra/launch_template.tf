resource "aws_launch_template" "webserver_launch_template" {
  name = "webserver_launch_template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }


  disable_api_termination = false

  ebs_optimized = true


  image_id  = "${lookup(var.AMIS, var.AWS_REGION)}"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.small"

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = [aws_security_group.instance-elb-sec-grp.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "webserver"
    }
  }
  user_data     = base64encode(data.template_file.webserver_config.rendered)

  }
data "template_file" "webserver_config"{
    template = file ("templates/user_data.sh.tpl")
  }
