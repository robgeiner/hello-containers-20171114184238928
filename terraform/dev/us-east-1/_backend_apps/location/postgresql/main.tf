#### Generic role for any instance in need of S3 Bucket access
resource "aws_iam_role" "postgres-gis_role" {
    name = "postgres-gis_role"
    assume_role_policy = "${file("default-assume.json")}"
}
resource "aws_iam_instance_profile" "postgres-gis_profile" {
    name = "postgres-gis_profile"
    role = "${aws_iam_role.postgres-gis_role.name}"
}
resource "aws_iam_policy" "postgres-gis_access" {
    name = "postgres-gis_access"
    policy = "${file("postgres-gis_policy.json")}"
}

resource "aws_iam_policy_attachment" "postgres-gis_attach" {
  name       = "postgres-gis_access"
  roles      = ["${aws_iam_role.postgres-gis_role.name}"]
  policy_arn = "${aws_iam_policy.postgres-gis_access.arn}"
}



resource "aws_ebs_volume" "postgres-gis" {
  availability_zone = "${element(split(",",data.terraform_remote_state.sun-managed-dev-us-east-1.private_2_zones), 0)}"
  type = "gp2"
  size = 300
  tags {
    Name = "postgres-gis-sdb"
  }
}

module "postgres-gis" {
  source = "git@github.com:TheWeatherCompany/tf-module-app.git?ref=0.6.9"
  app-name = "postgres-gis"
  environment = "${var.environment}"
  chef_repo = "platform"
  chef_role = "postgresql"
  region = "${var.region}"
  billing-tag = "SUN"
  node-subnet = "${data.terraform_remote_state.sun-managed-dev-us-east-1.private_2_ids}"
  node-zone = "${data.terraform_remote_state.sun-managed-dev-us-east-1.private_2_zones}"
  zone_id = "${var.zone_id}"
  ssh-key-name = "${var.ssh_key_name}"
  security_groups = "${data.terraform_remote_state.sun-managed-dev-us-east-1.basic_access_sg},${data.terraform_remote_state.sun-managed-dev-us-east-1.internal_sg}"
  vpc = "${data.terraform_remote_state.sun-managed-dev-us-east-1.vpc_id}"
  bastion_host = "${data.terraform_remote_state.sun-managed-dev-us-east-1.bastion_ip}"
  bastion_user = "ops-user"
  validation_client_name = "${var.validation_client_name}"
  validation_key_path = "${var.validation_key_path}"
  instance_type = "c4.2xlarge"
  app-port = "5432"
  iam-profile = "postgres-gis_profile"
}
