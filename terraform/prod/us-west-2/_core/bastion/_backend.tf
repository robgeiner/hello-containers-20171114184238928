# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/us-west-2/_core/bastion/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod_us-west-2__core_bastion-locktable"
    region     = "us-east-1"
  }
}
