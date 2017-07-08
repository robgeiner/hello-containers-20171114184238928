module "iam" {
  source = "git::ssh://git@github.com/TheWeatherCompany/cognitive-terraform-modules.git//terraform/iam"
  environment = "${var.ENVIRONMENT}"
  project = "${var.PROJECT}"
  bucket_prefix = "${var.PROJECT_BUCKET_PREFIX}"
}
