# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/us-east-1/_core/logging/es-proxy/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev_us-east-1__core_logging_es-proxy-locktable"
    region     = "us-east-1"
  }
}
