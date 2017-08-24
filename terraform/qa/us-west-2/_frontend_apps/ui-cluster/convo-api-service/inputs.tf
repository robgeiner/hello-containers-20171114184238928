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

data "terraform_remote_state" "route53" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/_global/route53/terraform.tfstate"
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

data "terraform_remote_state" "app-repository" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_frontend_apps/ui-cluster/repository/convo-api/app/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}

data "terraform_remote_state" "config-repository" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_frontend_apps/ui-cluster/repository/convo-api/config/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}
