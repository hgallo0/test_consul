// autoscaling 

data "aws_ami" "image" {
  most_recent = true

  filter {
    name      = "name"
    values    = ["${var.ami_value}"]
  }

  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }

  owners      = ["${var.ami_owner}"]
}

// launch configuration for host

resource "aws_launch_configuration" "as_conf" {
  name_prefix     = "autoscale_"
  image_id        = "${data.aws_ami.image.id}"
  instance_type   = "${var.ec2_type}"
  key_name        = "${var.sshkey}"
  user_data       = "${data.template_file.ec2_template.rendered}"
  security_groups = ["${var.sec_groups}"]
  associate_public_ip_address = "${var.public_ip_bol}"

  lifecycle {
    create_before_destroy = true
  }
}


// user data file

data "template_file" "ec2_template" {
  template = "${file("${var.template}")}"
}

resource "aws_autoscaling_group" "autoscale_" {
  name                      = "${var.autoscale_name}"

  vpc_zone_identifier       = ["${var.subnet_ids}"]

  desired_capacity          = "${var.desired_capacity}"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = true
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tags = ["${concat(
      list(map("key", "Name", "value", var.name, "propagate_at_launch", true)),
      var.tags
   )}"]

  lifecycle {
    create_before_destroy = true
  }
}
