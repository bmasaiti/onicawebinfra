variable "AWS_ACCESS_KEY" {

}
variable "AWS_SECRET_KEY" {
}
variable "AWS_REGION" {
}

variable "AMIS" {
  type = map
  default = {
    //region = "amiID"
    ap-southeast-2 = "ami-08bd00d7713a39e7d"
  }
}

variable "webserver_instance_type" {
  type = string
  default = "t3.small"
}

variable "webserver_tags" {
  type = map
  default = {
    name = "webserver"
  }
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}

//ssh-keygen to generate public n private keypair .
variable "INSTANCE_DEVICE_NAME" {
  default = "ebs-volume-device"
}


variable "DESIRED_INSTANCES"{
  default = 2
}
variable "MIN_INSTANCES"{
  default = 1
}
variable "MAX_INSTANCES"{
  default = 5
}
