# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/_global/_remote_state/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev__global__remote_state-locktable"
    region     = "us-east-1"
  }
}
