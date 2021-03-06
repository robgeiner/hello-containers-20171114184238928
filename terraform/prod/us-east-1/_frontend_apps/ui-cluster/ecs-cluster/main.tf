#######  Security Groups  ##########
#
#  Define in here any ingress ports for the application.   This will get applied to the application load balancer.
#  e.g. if the application is receiving traffic on port 443 from the public internet, you need to define a SG rule to allow inbound traffic on 443 from the internet.
#
####################################


module "common-vpc" {
  source = "git::ssh://git@github.com/TheWeatherCompany/grid-env-modules.git//terraform/common-vpc"
}

# public SG

resource "aws_security_group" "ecs_alb-public_ingress_sg" {
  name = "${var.PROJECT}-${var.ENVIRONMENT}-${var.cluster_short_name}_ext_sg"
  description = "Allow communication with ecs_alb-public_ingress_sg alb"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  tags {
    Billing = "${var.BILLING_CODE}"
  }
}

resource "aws_security_group_rule" "ecs_alb-public_ext_ingress_443" {
  type = "ingress"
  from_port = "${data.terraform_remote_state.service-registry.external_lb_port}"
  to_port = "${data.terraform_remote_state.service-registry.external_lb_port}"
  protocol = "tcp"
  security_group_id = "${aws_security_group.ecs_alb-public_ingress_sg.id}"
  cidr_blocks = ["0.0.0.0/0"]
}

#####

module "alb-public" {
  source = "git::ssh://git@github.com/TheWeatherCompany/twc-ecs-modules.git//terraform/alb"
  name = "${var.ENVIRONMENT}-${var.cluster_short_name}-public"
  project = "${var.PROJECT}"
  security_group_ids = "${aws_security_group.ecs_alb-public_ingress_sg.id}"
  subnets = "${data.terraform_remote_state.vpc.public_subnet_ids}"
  billing_id = "${var.BILLING_CODE}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  idle_timeout = "${var.idle_timeout}"
  enable_access_logs = "true"
  access_logs_bucket_name = "${data.terraform_remote_state.access-logs.name}"
  access_logs_prefix = "public"
  internal = false
}

module "cluster" {
  source = "git::ssh://git@github.com/TheWeatherCompany/twc-ecs-modules.git//terraform/cluster"
  name = "${var.cluster_short_name}"
  config_file = "${var.config_file}"
  environment = "${var.ENVIRONMENT}"
  region = "${var.REGION}"
  project = "${var.PROJECT}"
  chef_role = "${var.chef_role}"
  chef_version = "${var.chef_version}"
  chef_organization = "${var.CHEF_ORGANIZATION}"
  chef_environment = "${var.CHEF_ENVIRONMENT}"
  chef_server_url = "${var.CHEF_SERVER_URL}"
  chef_client_name = "${var.CHEF_VALIDATION_CLIENT_NAME}"
  chef_client_key = "${var.CHEF_VALIDATION_KEY_NAME}"
  ssh_key_name = "${var.SSH_KEY_NAME}"
  billing_id = "${var.BILLING_CODE}"
  bootstrap_bucket_name = "${var.PROJECT_BUCKET_PREFIX}-${var.ENVIRONMENT}-bootstrap"
  alb_sg_count = "1"
  alb_sg_id = [ "${module.alb-public.sg_id}" ]
  instance_type = "${var.instance_type}"
  asg_max = "${var.asg_max}"
  asg_min = "${var.asg_min}"
  docker_version = "${var.docker_version}"
  docker_debug = "${var.docker_debug}"
  ecs_agent_version = "${var.ecs_agent_version}"
  ecs_agent_log_level = "${var.ecs_agent_log_level}"
  monitoring_agent = "${var.MONITORING_AGENT}"
  monitoring_agent_key = "${var.MONITORING_AGENT_KEY}"
  monitoring_agent_version = "${var.monitoring_agent_version}"
  elk_logging_endpoint = "${data.terraform_remote_state.logging.endpoint}"
  elk_logging_region = "${data.terraform_remote_state.logging.region}"
  logmet_install = "${var.logmet_install}"
  logmet_host = "${var.logmet_host}"
  logmet_logging_token = "${var.LOGMET_LOGGING_TOKEN}"
  logmet_space_id = "${var.LOGMET_SPACE_ID}"
  repository_auth_data_url = "${var.REPOSITORY_AUTH_DATA_URL}"
  repository_auth_data_username = "${var.REPOSITORY_AUTH_DATA_USERNAME}"
  repository_auth_data_password = "${var.REPOSITORY_AUTH_DATA_PASSWORD}"
  repository_auth_data_email = "${var.REPOSITORY_AUTH_DATA_EMAIL}"
  cluster_ami = "${var.ecs-cluster-ami}"
  iam_instance_profile = "${data.terraform_remote_state.iam.baseInstanceProfile_name}"
  security_group_ids = "${data.terraform_remote_state.bastion.basic_access_security_group_id}"
  vpc_zone_identifiers = "${data.terraform_remote_state.vpc.private_subnet_ids}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  # not used but needed
  services_parameters_file_name = "vars"
  services_parameters_file_type = "env"
}

# required to have a default. This one will 503 since there will never be a target registering with the group
module "default-tg" {
  source = "git::ssh://git@github.com/TheWeatherCompany/twc-ecs-modules.git//terraform/target-group"
  name = "${var.ENVIRONMENT}-${var.cluster_short_name}-${data.terraform_remote_state.service-registry.default_name}"
  project = "${var.PROJECT}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  port = "${data.terraform_remote_state.service-registry.default_port}"
  healthcheck_path = "${data.terraform_remote_state.service-registry.default_healthcheck_path}"
  healthcheck_protocol = "${data.terraform_remote_state.service-registry.default_healthcheck_protocol}"
}

resource "aws_alb_listener" "public-listener" {
   load_balancer_arn = "${module.alb-public.arn}"
   port = "${data.terraform_remote_state.service-registry.external_lb_port}"
   protocol = "${data.terraform_remote_state.service-registry.external_lb_protocol}"
   ssl_policy = "ELBSecurityPolicy-2016-08"
   certificate_arn = "${data.terraform_remote_state.route53.certificate_arn}"

   default_action {
     target_group_arn = "${module.default-tg.arn}"
     type = "forward"
   }
}

resource "aws_route53_record" "cogads-ui" {
  zone_id = "${data.terraform_remote_state.route53.zone_id}"
  name = "ui-${var.ENVIRONMENT}-${var.REGION}"
  type = "CNAME"
  ttl = "60"
  records = ["${module.alb-public.dns_name}"]
}
