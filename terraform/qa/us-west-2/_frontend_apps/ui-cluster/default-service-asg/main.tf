#########   cogads-chef-ui_server_sg   ###############

resource "aws_security_group" "cogads-chef-ui_server_sg" {
  name = "${var.PROJECT}-chef-ui_server_sg"
  description = "Allow communication with cogads-chef-ui server"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  tags {
    Billing = "${var.BILLING_CODE}"
  }
}

resource "aws_security_group_rule" "cogads-chef-ui_server_ingress_from_elb_8080" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  security_group_id = "${aws_security_group.cogads-chef-ui_server_sg.id}"
  cidr_blocks = ["10.0.0.0/8"]
  #source_security_group_id = "${aws_security_group.cogads-chef-ui_ext_sg.id}"
}

resource "aws_security_group_rule" "cogads-chef-ui_server_ingress_from_self_800x" {
  type = "ingress"
  from_port = 8008
  to_port = 8008
  protocol = "tcp"
  security_group_id = "${aws_security_group.cogads-chef-ui_server_sg.id}"
  self = true
}

resource "aws_security_group_rule" "cogads-chef-ui_server_engress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.cogads-chef-ui_server_sg.id}"
}


######## Launch Configuration ###########
data "template_file" "cogads-chef-ui_lc_ud" {
  template = "${file("./user-data/bootstrap-userdata.template.sh")}"
  vars {
    environment = "${var.ENVIRONMENT}"
    region = "${var.REGION}"
    node_name_prefix = "${var.PROJECT}-chef-ui"
    bootstrap_bucket_name = "${var.PROJECT_BUCKET_PREFIX}-${var.ENVIRONMENT}-bootstrap"
    chef_environment = "${var.environment}-${var.REGION}"
    chef_role = "cogads-chef-ui"
    chef_version = "${var.chef_version}"
  }
}

resource "aws_launch_configuration" "cogads-chef-ui" {
    name_prefix = "${var.PROJECT}-${var.chef-ui-lc}"
    iam_instance_profile = "${data.terraform_remote_state.iam.baseInstanceProfile_name}"
    key_name = "${var.SSH_KEY_NAME}"
    user_data = "${data.template_file.cogads-chef-ui_lc_ud.rendered}"
    security_groups = ["${aws_security_group.cogads-chef-ui_server_sg.id}",
                       "${data.terraform_remote_state.bastion.basic_access_security_group_id}"]
    lifecycle {
      create_before_destroy = true
    }
    image_id = "${var.chef-ui-ami}"
    instance_type = "m4.large"
}


#########################################
######## Autoscaling Group   ############
#########################################

resource "aws_autoscaling_group" "cogads-chef-ui" {
  name = "${var.PROJECT}-chef-ui-${var.ENVIRONMENT}-asg"
  vpc_zone_identifier = ["${element(split(",",data.terraform_remote_state.vpc.private_subnet_ids),2)}"]

  max_size = "${var.chef-ui-asg-max}"
  min_size = "${var.chef-ui-asg-min}"
  health_check_grace_period = 600
  health_check_type = "ELB"
  force_delete = true
  enabled_metrics = ["GroupMinSize",
                     "GroupMaxSize",
                     "GroupDesiredCapacity",
                     "GroupInServiceInstances",
                     "GroupPendingInstances",
                     "GroupStandbyInstances",
                     "GroupTerminatingInstances",
                     "GroupTotalInstances"]
  #load_balancers = ["${aws_elb.cogads-chef-ui_ext_elb.id}"]
  target_group_arns = ["${data.terraform_remote_state.cluster.tg_default_arn}"]
  launch_configuration = "${aws_launch_configuration.cogads-chef-ui.name}"

  tag {
    key = "Billing"
    value = "${var.BILLING_CODE}"
    propagate_at_launch = true
  }
}

####### Scale up Policy #########
resource "aws_autoscaling_policy" "cogads-chef-ui_scale_up" {
  name = "CPU scale up"
  scaling_adjustment = 10
  adjustment_type = "PercentChangeInCapacity"
  min_adjustment_magnitude = 3
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.cogads-chef-ui.name}"
}

resource "aws_cloudwatch_metric_alarm" "cogads-chef-ui_scale_up_cpu" {
    alarm_name = "${var.PROJECT}-chef-ui-${var.ENVIRONMENT} scale up from CPU"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "300"
    statistic = "Average"
    threshold = "65"
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.cogads-chef-ui.name}"
    }
    alarm_description = "This metric monitors cogads-chef-ui cpu utilization"
    alarm_actions = ["${aws_autoscaling_policy.cogads-chef-ui_scale_up.arn}"]
}
####### Scale down Policy #########
resource "aws_autoscaling_policy" "cogads-chef-ui_scale_down" {
  name = "CPU scale down"
  scaling_adjustment = -5
  adjustment_type = "PercentChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = "${aws_autoscaling_group.cogads-chef-ui.name}"
}

resource "aws_cloudwatch_metric_alarm" "cogads-chef-ui_scale_down_cpu" {
    alarm_name = "${var.PROJECT}-chef-ui-${var.ENVIRONMENT} scale down from CPU"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "1200"
    statistic = "Average"
    threshold = "30"
    dimensions {
        AutoScalingGroupName = "${aws_autoscaling_group.cogads-chef-ui.name}"
    }
    alarm_description = "This metric monitors cogads-chef-ui cpu utilization"
    alarm_actions = ["${aws_autoscaling_policy.cogads-chef-ui_scale_down.arn}"]
}
