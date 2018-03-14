variable "ami_value" {
  description = "image name"
}

variable "ami_owner" {
  description = "ami owner id"
}

variable "ec2_type" {
  description = "type of ec2 instance"
}

variable "sshkey" {
  description = "ssh key"
}

variable "autoscale_name" {
  description = " autoscaling group name"
}

variable "subnet_ids" {
  type        = "list"
  description = "A list of subnet ids"
}


variable "min_size" {}
variable "max_size" {}
variable "public_ip_bol" {}
variable "template" {}
variable "desired_capacity" {}
variable "tag_key" {}
variable "tag_value" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "sec_groups" {}

variable "name" {}
variable "tags" {
  type = "list"
}

variable "health_check_type" {}
