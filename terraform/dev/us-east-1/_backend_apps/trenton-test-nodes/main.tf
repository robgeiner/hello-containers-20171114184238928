module "trenton-test-master" {
  source = "git@github.com:TheWeatherCompany/tf-module-app.git?ref=0.6.5"
  app-name = "trenton-test-master"
  environment = "${var.environment}"
  chef_repo = "platform"
  chef_role = "test-node"
  region = "${var.region}"
  billing-tag = "SUN"
  node-subnet = "${data.terraform_remote_state.sun-managed-dev-us-east-1.private_2_ids}"
  node-zone = "${data.terraform_remote_state.sun-managed-dev-us-east-1.private_2_zones}"
  zone_id = "${var.zone_id}"
  ssh-key-name = "${var.ssh_key_name}"
  security_groups = "${data.terraform_remote_state.sun-managed-dev-us-east-1.basic_access_sg},${data.terraform_remote_state.sun-managed-dev-us-east-1.internal_sg}"
  vpc = "${data.terraform_remote_state.sun-managed-dev-us-east-1.vpc_id}"
  bastion_host = "${data.terraform_remote_state.sun-managed-dev-us-east-1.bastion_ip}"
  bastion_private_key = "${var.bastion_private_key}"
  private_key = "${var.private_key}"
  validation_client_name = "${var.validation_client_name}"
  validation_key_path = "${var.validation_key_path}"
  instance_type = "t2.medium"
}

module "trenton-test-slave" {
  source = "git@github.com:TheWeatherCompany/tf-module-app.git?ref=0.6.5"
  app-name = "trenton-test-slave"
  environment = "${var.environment}"
  chef_repo = "platform"
  chef_role = "test-node"
  region = "${var.region}"
  billing-tag = "SUN"
  node-subnet = "${data.terraform_remote_state.sun-managed-dev-us-east-1.private_2_ids}"
  node-zone = "${data.terraform_remote_state.sun-managed-dev-us-east-1.private_2_zones}"
  zone_id = "${var.zone_id}"
  ssh-key-name = "${var.ssh_key_name}"
  security_groups = "${data.terraform_remote_state.sun-managed-dev-us-east-1.basic_access_sg},${data.terraform_remote_state.sun-managed-dev-us-east-1.internal_sg}"
  vpc = "${data.terraform_remote_state.sun-managed-dev-us-east-1.vpc_id}"
  bastion_host = "${data.terraform_remote_state.sun-managed-dev-us-east-1.bastion_ip}"
  bastion_private_key = "${var.bastion_private_key}"
  private_key = "${var.private_key}"
  validation_client_name = "${var.validation_client_name}"
  validation_key_path = "${var.validation_key_path}"
  instance_type = "t2.medium"
  instances = "2"
}
