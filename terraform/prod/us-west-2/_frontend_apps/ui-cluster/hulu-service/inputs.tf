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

data "terraform_remote_state" "ec-redis" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_frontend_apps/ui-cluster/ec-redis/terraform.tfstate"
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
    key     = "${var.ENVIRONMENT}/${var.REGION}/_frontend_apps/ui-cluster/repository/hulu/terraform.tfstate"
    region  = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}
