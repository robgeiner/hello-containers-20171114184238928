# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/us-east-1/_core/alb-access-logs/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev_us-east-1__core_alb-access-logs-locktable"
    region     = "us-east-1"
  }
}
