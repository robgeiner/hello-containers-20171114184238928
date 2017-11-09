module "common-ami" {
  source = "git::ssh://git@github.com/TheWeatherCompany/grid-env-modules.git//terraform/common-ami"
  region = "${var.REGION}"
}
module "common-vpc" {
  source = "git::ssh://git@github.com/TheWeatherCompany/grid-env-modules.git//terraform/common-vpc"
}

#######  Security Groups   ##########

resource "aws_security_group" "es-proxy_ext_sg" {
  name = "${var.PROJECT}-es-proxy_ext_sg"
  description = "Allow communication with es-proxy_ext_sg ELB"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  tags {
    Billing = "${var.BILLING_CODE}"
  }
}

resource "aws_security_group_rule" "es-proxy_ext_ingress_from_twc_443" {
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.es-proxy_ext_sg.id}"
  cidr_blocks = ["${split(",",module.common-vpc.twc_cidr_blocks_offices)}","${split(",",var.additional_ips)}"]
}

resource "aws_security_group_rule" "es-proxy_ext_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.es-proxy_ext_sg.id}"
}

#########   es-proxy_server_sg   ###############

resource "aws_security_group" "es-proxy_server_sg" {
  name = "${var.PROJECT}-es-proxy_server_sg"
  description = "Allow communication with es-proxy server"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  tags {
    Billing = "${var.BILLING_CODE}"
  }
}

resource "aws_security_group_rule" "es-proxy_server_ingress_from_elb_8080" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.es-proxy_server_sg.id}"
  source_security_group_id = "${aws_security_group.es-proxy_ext_sg.id}"
}

resource "aws_security_group_rule" "es-proxy_server_ingress_from_priv_8081" {
  type = "ingress"
  from_port = 8081
  to_port = 8081
  protocol = "tcp"
  security_group_id = "${aws_security_group.es-proxy_server_sg.id}"
  cidr_blocks = ["10.0.0.0/24"]
}

resource "aws_security_group_rule" "es-proxy_server_ingress_from_self_9200" {
  type = "ingress"
  from_port = 9200
  to_port = 9200
  protocol = "tcp"
  security_group_id = "${aws_security_group.es-proxy_server_sg.id}"
  self = true
}

resource "aws_security_group_rule" "es-proxy_server_engress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.es-proxy_server_sg.id}"
}

######## Load Balancer Configuration ###########

resource "aws_elb" "es-proxy_ext_elb" {
  name = "${var.PROJECT}-es-proxy-${var.ENVIRONMENT}-lb"
  security_groups = ["${aws_security_group.es-proxy_ext_sg.id}"]
  subnets = ["${element(split(",", data.terraform_remote_state.vpc.public_subnet_ids),1)}"]

  #access_logs {
  #  bucket = "${var.elb_logs_bucket_name}"
  #  interval = 5
  #}

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${data.terraform_remote_state.route53.certificate_arn}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "tcp:8080"
    interval = 30
  }

  idle_timeout = 60
  cross_zone_load_balancing = true
  connection_draining = true
  connection_draining_timeout = 300
  internal = false

  tags {
    Name = "es-proxy-${var.ENVIRONMENT}-ext-lb"
    Billing = "${var.BILLING_CODE}"
  }
}

######## Launch Configuration ###########
data "template_file" "es-proxy_lc_ud" {
  template = "${file("${path.module}/bootstrap-userdata.template.sh")}"
  vars {
    environment = "${var.ENVIRONMENT}"
    region = "${var.REGION}"
    node_name_prefix = "${var.PROJECT}-es-proxy"
    bootstrap_bucket_name = "${var.PROJECT_BUCKET_PREFIX}-${var.ENVIRONMENT}-bootstrap"
    chef_server_url = "${var.CHEF_SERVER_URL}"
    chef_environment = "${var.CHEF_ENVIRONMENT}"
    chef_role = "${var.chef_role}"
    chef_version = "${var.chef_version}"
    chef_organization = "${var.CHEF_ORGANIZATION}"

    userdata = <<-EOF
    "twc-es-proxy": {
      "endpoint": {
        "hostname": "${data.terraform_remote_state.logging.endpoint}",
        "region": "${data.terraform_remote_state.logging.region}"
      },
      "user": {
        "name": "${var.ES_PROXY_USERNAME}",
        "password": "${var.ES_PROXY_PASSWORD}"
      }
    }
    EOF
  }
}

resource "aws_launch_configuration" "es-proxy" {
    name_prefix = "${var.PROJECT}-es-proxy-lc"
    iam_instance_profile = "${data.terraform_remote_state.iam.baseInstanceProfile_name}"
    key_name = "${var.SSH_KEY_NAME}"
    user_data = "${data.template_file.es-proxy_lc_ud.rendered}"
    security_groups = ["${aws_security_group.es-proxy_server_sg.id}",
                       "${data.terraform_remote_state.bastion.basic_access_security_group_id}"]

    lifecycle {
      create_before_destroy = true
    }
    image_id = "${module.common-ami.amis_community_centos_7_hvm}"
    instance_type = "${var.instance_type}"
}


#########################################
######## Autoscaling Group   ############
#########################################

resource "aws_autoscaling_group" "es-proxy" {
  name = "${var.PROJECT}-es-proxy-${var.ENVIRONMENT}-asg"
  vpc_zone_identifier = ["${element(split(",", data.terraform_remote_state.vpc.private_subnet_ids),1)}"]

  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  health_check_grace_period = 600
  health_check_type = "ELB"
  force_delete = true
  load_balancers = ["${aws_elb.es-proxy_ext_elb.id}"]
  launch_configuration = "${aws_launch_configuration.es-proxy.name}"

  tag {
    key = "Billing"
    value = "${var.BILLING_CODE}"
    propagate_at_launch = true
  }
}

######## Route 53 ##########

resource "aws_route53_record" "es-proxy_ext_elb" {
  zone_id = "${data.terraform_remote_state.route53.zone_id}"
  name = "${var.PROJECT}-es-proxy-${var.ENVIRONMENT}-${replace(var.REGION, "-", "")}"
  type = "A"
  alias {
    name = "${aws_elb.es-proxy_ext_elb.dns_name}"
    zone_id = "${aws_elb.es-proxy_ext_elb.zone_id}"
    evaluate_target_health = true
  }
}
