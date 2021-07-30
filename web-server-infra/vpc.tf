resource "aws_vpc" "BUDWELL_LAB_VPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

}
#subnets

resource "aws_subnet" "PUBLIC_SUB_BUDWELL_LAB_0" {
  vpc_id                  = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-southeast-2a"

}

resource "aws_subnet" "PUBLIC_SUB_BUDWELL_LAB_1" {
  vpc_id                  = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-southeast-2b"

}
resource "aws_subnet" "PRIVATE_SUB_BUDWELL_LAB_0" {
  vpc_id                  = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = "false"

}

resource "aws_subnet" "PRIVATE_SUB_BUDWELL_LAB_1" {
  vpc_id                  = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = "false"

}



#INTERNET GW
resource "aws_internet_gateway" "INTERNET_GW" {
  vpc_id = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  #tags{
  #  Name= "internet-gw"
  #}
}

#ROUTE TABLES
resource "aws_route_table" "main-public" {
  vpc_id = "${aws_vpc.BUDWELL_LAB_VPC.id}"
  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.INTERNET_GW.id}"
  }

}

#ROUTE associations PUBLIC
resource "aws_route_table_association" "main-public-0" {
  subnet_id      = "${aws_subnet.PUBLIC_SUB_BUDWELL_LAB_0.id}"
  route_table_id = "${aws_route_table.main-public.id}"
}
