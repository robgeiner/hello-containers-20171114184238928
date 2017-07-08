#######  Security Groups   #########
resource "aws_security_group" "elb" {
  name = "oapi-monolith-varnish-lb_sg"
  description = "Security Group for oapi-monolith-varnish Load Balancer"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  tags {
    Name = "oapi-monolith-varnish-lb_sg"
  }
}

resource "aws_security_group" "app" {
  name = "oapi-monolith-varnish_sg"
  description = "Security Group for oapi-monolith-varnish Instances"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  tags {
    Name = "oapi-monolith-varnish_sg"
  }
}

resource "aws_security_group_rule" "elb_enter" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.elb.id}"
}

resource "aws_security_group_rule" "app_enter" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.elb.id}"
  security_group_id = "${aws_security_group.app.id}"
}

resource "aws_security_group_rule" "elb_exit" {
  type = "egress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.app.id}"
  security_group_id = "${aws_security_group.elb.id}"
}

resource "aws_security_group_rule" "app_exit" {
  type = "egress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.app.id}"
}


######## Load Balancer Configuration ###########
# INTERNAL
resource "aws_elb" "oapi-monolith-varnish-int-lb" {
  name = "oapi-mono-varnish-int-${var.ENVIRONMENT}-lb"
  security_groups = ["${aws_security_group.elb.id}"]
  subnets = ["${split(",",data.terraform_remote_state.vpc.private_2_subnet_ids)}"]
  internal = true

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:8080/heartbeat"
    interval = 10
  }

  idle_timeout = 400
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 30

  tags {
    Name = "oapi-monolith-varnish-int-${var.ENVIRONMENT}-lb"
    Billing = "SUN"
    Owner = "b2c"
    Team = "b2c"
  }
}

# EXTERNAL
resource "aws_elb" "oapi-monolith-varnish-ext-lb" {
  name = "oapi-mono-varnish-ext-${var.ENVIRONMENT}-lb"
  security_groups = ["${aws_security_group.elb.id}"]
  subnets = ["${split(",",data.terraform_remote_state.vpc.public_2_subnet_ids)}"]
  internal = false

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:8080/heartbeat"
    interval = 10
  }

  idle_timeout = 400
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 30

  tags {
    Name = "oapi-monolith-varnish-ext-${var.ENVIRONMENT}-lb"
    Billing = "SUN"
    Owner = "b2c"
    Team = "b2c"
  }
}


######## Route 53 ##########
resource "aws_route53_record" "oapi-monolith-varnish-int-lb" {
  zone_id = "${data.terraform_remote_state.route53.zone_id}"
  name = "oapi-monolith-varnish-int-${var.ENVIRONMENT}-${replace(var.REGION, "-", "")}-lb"
  type = "A"
  alias {
    name = "${aws_elb.oapi-monolith-varnish-int-lb.dns_name}"
    zone_id = "${aws_elb.oapi-monolith-varnish-int-lb.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "oapi-monolith-varnish-ext-lb" {
  zone_id = "${data.terraform_remote_state.route53.zone_id}"
  name = "oapi-monolith-varnish-ext-${var.ENVIRONMENT}-${replace(var.REGION, "-", "")}-lb"
  type = "A"
  alias {
    name = "${aws_elb.oapi-monolith-varnish-ext-lb.dns_name}"
    zone_id = "${aws_elb.oapi-monolith-varnish-ext-lb.zone_id}"
    evaluate_target_health = true
  }
}


######## Launch Configuration ###########
data "template_file" "oapi_monolith_varnish_lc_ud" {
  template = "${file("bootstrap-userdata.template.sh")}"
  vars {
    environment = "${var.ENVIRONMENT}"
    node_name_prefix = "oapi-monolith-varnish"
    chef_role = "oapi-monolith-varnish"
    chef_version = "12.11.18"
    region = "${var.REGION}"
  }
}

resource "aws_launch_configuration" "oapi-monolith-varnish" {
    name_prefix = "${var.oapi-monolith-varnish-lc-prefix}"
    iam_instance_profile = "${data.terraform_remote_state.iam.varnish_profile_name}"
    key_name = "${var.SSH_KEY_NAME}"
    user_data = "${data.template_file.oapi_monolith_varnish_lc_ud.rendered}"
    security_groups = ["${aws_security_group.app.id}", "${data.terraform_remote_state.vpc.basic_access_sg_id}" ]
    lifecycle {
      create_before_destroy = true
    }
    image_id = "${var.oapi-monolith-varnish-ami}"
    instance_type = "${var.oapi-monolith-varnish-size}"
}


######## Autoscaling Group ############
resource "aws_autoscaling_group" "oapi-monolith-varnish" {
  name = "oapi-monolith-varnish-asg"
  vpc_zone_identifier = ["${split(",",data.terraform_remote_state.vpc.private_2_subnet_ids)}"]
  max_size = "${var.oapi-monolith-varnish-asg-max}"
  min_size = "${var.oapi-monolith-varnish-asg-min}"
  health_check_grace_period = 300
  health_check_type = "ELB"
  force_delete = true
  termination_policies = ["OldestLaunchConfiguration","ClosestToNextInstanceHour"]
  load_balancers = ["${aws_elb.oapi-monolith-varnish-int-lb.id}", "${aws_elb.oapi-monolith-varnish-ext-lb.id}"]
  launch_configuration = "${aws_launch_configuration.oapi-monolith-varnish.name}"
  enabled_metrics = ["GroupMinSize",
                     "GroupMaxSize",
                     "GroupDesiredCapacity",
                     "GroupInServiceInstances",
                     "GroupPendingInstances",
                     "GroupStandbyInstances",
                     "GroupTerminatingInstances",
                     "GroupTotalInstances"]

  tag {
    key = "Billing"
    value = "SUN"
    propagate_at_launch = true
  }
  tag {
    key = "Owner"
    value = "b2c"
    propagate_at_launch = true
  }
  tag {
    key = "Team"
    value = "b2c"
    propagate_at_launch = true
  }
}


######## Outputs ############
output "oapi_monolith_varnish_int_elb_dns" {
  value = "${aws_route53_record.oapi-monolith-varnish-int-lb.fqdn}"
}

output "oapi_monolith_varnish_ext_elb_dns" {
  value = "${aws_route53_record.oapi-monolith-varnish-ext-lb.fqdn}"
}
