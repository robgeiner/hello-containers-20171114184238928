# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "sun-b2c-devops-dev-remote-state-bucket"
    key        = "/dev/us-east-1/_backend_apps/dist-ng/sqs/terraform.tfstate"
    lock_table = "terraform-sun-b2c-devops-_dev_us-east-1__backend_apps_dist-ng_sqs-locktable"
    region     = "us-east-1"
  }
}
