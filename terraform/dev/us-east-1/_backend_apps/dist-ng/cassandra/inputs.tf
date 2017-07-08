data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key    = "${var.ENVIRONMENT}/${var.REGION}/_core/vpc/terraform.tfstate"
    region = "${var.REMOTE_STATE_BUCKET_REGION}"
  }
}

data "terraform_remote_state" "sun-managed-dev-us-east-1" {
  backend = "s3"
  config {
    bucket = "sun-managed-dev-us-east-1-remote-state-bucket"
    key    = "config-dev-us-east-1/terraform.tfstate"
    region = "us-east-1"
  }
}
