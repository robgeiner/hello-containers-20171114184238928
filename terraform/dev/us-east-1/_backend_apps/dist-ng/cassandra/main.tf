module "dist-ng-ami" {
  source = "git::ssh://git@github.com/TheWeatherCompany/grid-env-modules.git//terraform/common-ami?ref=v0.2.4"
  region = "${var.REGION}"
}

data "template_file" "security_group_ids" {
  template = "$${basic_sg},$${internal_sg},$${cassandra_sg}"
  vars {
    basic_sg = "${data.terraform_remote_state.vpc.basic_access_sg_id}"
    internal_sg = "${data.terraform_remote_state.vpc.internal_sg_id}"
    cassandra_sg = "${data.terraform_remote_state.sun-managed-dev-us-east-1.cassandra-sg}"
  }
}

module "dist-ng-cassandra" {
  source = "git::ssh://git@github.com/TheWeatherCompany/sun-env-modules.git//terraform/cassandra-cluster-ebs?ref=0.7.11"

  environment = "${var.ENVIRONMENT}"
  region = "${var.REGION}"

  name_prefix = "${var.name_prefix}"
  cluster_short_name = "${var.cluster_short_name}"

  node_count = "${var.node_count}"
  seed_count = "${var.seed_count}"

  ami_id = "${module.dist-ng-ami.amis_community_centos_7_hvm}"
  ami_user = "${var.ami_user}"
  instance_type = "${var.instance_type}"
  ebs_optimized = "${var.ebs_optimized}"

  data_device_gb = "${var.data_device_gb}"
  commitlog_device_gb = "${var.commitlog_device_gb}"

  # The Terraform data source variables are taken from the 'sun-env-tf' repository.
  availability_zones = "${data.terraform_remote_state.vpc.availability_zones}"
  subnets = "${data.terraform_remote_state.vpc.public_subnet_ids}"
  security_group_ids = "${data.template_file.security_group_ids.rendered}"
  iam_profile = "${data.terraform_remote_state.sun-managed-dev-us-east-1.cassandra-iam-instance-profile-entcass-name}"
  ssh_key_name = "${var.SSH_KEY_NAME}"

  bastion_host = "${data.terraform_remote_state.sun-managed-dev-us-east-1.bastion_ip}"
  bastion_user = "${var.bastion_user}"

  billing = "${var.billing}"
  tags = "${var.tags}"

  role = "${var.chef_role}"
  initial_run_list = "${var.initial_run_list}"

  chef_server_url = "${var.CHEF_SERVER_URL}"
  chef_version = "${var.chef_version}"
  validation_client_name = "${var.CHEF_VALIDATION_CLIENT_NAME}"
  validation_key_path = "${var.CHEF_VALIDATION_KEY_PATH}"
}
