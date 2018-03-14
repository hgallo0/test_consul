provider "aws" {
  region = "us-east-1"
  profile    = "contino-els-hgallo"
}

data "terraform_remote_state" "remote_state" {
    backend = "s3"
    config {
        bucket = "state"
        key = "prod/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "prod_lock"
        profile = "contino-els-hgallo"
    }
}

// consul nodes 
module "ecs" {
  source = "./modules/autoscaling"
#  source = "github.com/contino/ecs.git//terraform/modules/autoscaling"
#  version = "v1.1.0"

  ami_value        = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180109"
  ami_owner        = "099720109477"
  ec2_type         = "t2.micro"
  sshkey           = "contino"
  autoscale_name   = "consul"
  desired_capacity = "1"
  min_size         = "1"
  max_size         = "1"
  health_check_type= "EC2"
  template         = "./consul.tpl"
  public_ip_bol    = "false"
  sec_groups       = "${data.terraform_remote_state.remote_state.default_sec_group}"
  subnet_ids       = ["${data.terraform_remote_state.remote_state.subnets_private}"]
  cluster_name     = "ecs_consul"
  vpc_id           = "${data.terraform_remote_state.remote_state.vpc_id}"
#  instance_profile = "ecs_profile"
  tag_key          = "Name"
  tag_value        = "consul_prod"

  tags = [
  {
    "key" = "Terraform"
    "value" = "true"
    "propagate_at_launch" = true
  },
  {
    "key" = "Env"
    "value" = "consul"
    "propagate_at_launch" = true
  },
  ]

  name = "consul_nodes"
}
