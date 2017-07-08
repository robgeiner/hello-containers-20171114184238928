# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/_global/iam/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev__global_iam-locktable"
    region     = "us-east-1"
  }
}
