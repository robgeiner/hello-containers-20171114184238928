# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/us-west-2/_core/alb-access-logs/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod_us-west-2__core_alb-access-logs-locktable"
    region     = "us-east-1"
  }
}
