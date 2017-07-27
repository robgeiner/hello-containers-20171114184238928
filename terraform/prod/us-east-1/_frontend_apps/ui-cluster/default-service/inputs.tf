data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_core/vpc/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/_global/iam/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_core/bastion/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_frontend_apps/ui-cluster/ecs-cluster/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}

data "terraform_remote_state" "service-registry" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_frontend_apps/ui-cluster/service-registry/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}

data "terraform_remote_state" "repository" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_frontend_apps/ui-cluster/repository/default/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}
