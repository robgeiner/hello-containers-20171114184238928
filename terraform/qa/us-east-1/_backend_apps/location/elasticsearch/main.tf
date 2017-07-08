module "location-elasticsearch" {
  source = "git@github.com:TheWeatherCompany/tf-module-app_behind_elb.git?ref=0.2.22"
  app-name = "location-elasticsearch"
  environment = "${var.environment}"
  chef_repo = "platform"
  chef_role = "elasticsearch-location"
  region = "${var.region}"
  billing-tag = "SUN"
  node-subnet = "${data.terraform_remote_state.sun-managed-qa-us-east-1.private_2_ids}"
  node-zone =  "${data.terraform_remote_state.sun-managed-qa-us-east-1.private_2_zones}"
  elb-subnet = "${data.terraform_remote_state.sun-managed-qa-us-east-1.private_2_ids}"
  elb_internal = "true"
  zone_id = "${var.zone_id}"
  ssh-key-name = "${var.ssh_key_name}"
  validation_client_name = "${var.validation_client_name}"
  validation_key_path = "${var.validation_key_path}"
  security_groups = "${data.terraform_remote_state.sun-managed-qa-us-east-1.basic_access_sg},${data.terraform_remote_state.sun-managed-qa-us-east-1.internal_sg}"
  vpc = "${data.terraform_remote_state.sun-managed-qa-us-east-1.vpc_id}"
  bastion_user = "ops-user"
  bastion_host = "${data.terraform_remote_state.sun-managed-qa-us-east-1.bastion_ip}"
  instance_type = "i3.4xlarge"
  private_key = "${var.private_key}"
  bastion_private_key = "${var.bastion_private_key}"
  iam-profile = "elasticsearch"
  instances = "${var.instance_count}"
}

resource "aws_ebs_volume" "location-elasticsearch" {
  count = "${var.instance_count}"
  availability_zone = "${(element(split(",","${data.terraform_remote_state.sun-managed-qa-us-east-1.private_2_zones}"), count.index))}"
  size = 300
  tags {
    Name = "location-elasticsearch-${var.environment}-${replace(element(split(",","${data.terraform_remote_state.sun-managed-qa-us-east-1.private_2_zones}"), count.index), "-", "")}-${format("%02d",count.index + 1)}-sdb"
  }
}
