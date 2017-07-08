## SUN remote state
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.SUN_MANAGED_STATE_BUCKET}"
    key = "${var.SUN_MANAGED_STATE_KEY}"
    region = "${var.SUN_MANAGED_STATE_REGION}"
  }
}
