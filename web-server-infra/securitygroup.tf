// data "aws_subnet_ids" "web_app"{
//   vpc_id = "${aws_vpc.BUDWELL_LAB_VPC.id}"
// }
//
// data "aws_subnet" "web_app"{
//   count = length(data.aws_subnet_ids.web_app.ids)
//   id = tolist(data.aws_subnet_ids.web_app.ids)[count.index]
// }


resource "aws_security_group" "elb-security-group" {
  vpc_id      = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  name        = "elb-security-group"
  description = "security group for the elb"
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance-elb-sec-grp" {
  vpc_id      = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  name        = "instance-elb-sec-grp"


  tags = {
    Name = "webserver-host-sg"
  }
}

 resource "aws_security_group" "allow-ssh" {
   vpc_id = "${aws_vpc.BUDWELL_LAB_VPC.id}"
   name = "allow-ssh"
   description = "security group to allow ssh "
   egress {
     from_port = 0
     to_port = 0
     protocol = "-1"
     cidr_blocks = [
       "0.0.0.0/0"]
   }
   ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = [
       "1.136.25.201/32"]
   }
 }
   resource "aws_security_group_rule" "webserver_ingress_rule" {
   security_group_id = aws_security_group.instance-elb-sec-grp.id
   from_port       = 80
   to_port         = 80
   protocol        = "tcp"
   type = "ingress"
     source_security_group_id = aws_security_group.elb-security-group
 }

  resource "aws_security_group_rule" "webserver_egress_rule" {
    security_group_id = aws_security_group.instance-elb-sec-grp.id
    type =  "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }