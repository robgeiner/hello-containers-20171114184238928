data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.REMOTE_STATE_BUCKET_NAME}"
    key     = "${var.ENVIRONMENT}/${var.REGION}/_core/vpc/terraform.tfstate"
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
