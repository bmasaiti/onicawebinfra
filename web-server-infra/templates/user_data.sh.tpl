#!/bin/bash
yum -y update
yum -y install httpd
sudo usermod -a -G apache ec2-user
systemctl start httpd.service
systemctl enable httpd.service
echo “Hello World from $(hostname -f)” > /var/www/html/index.html
