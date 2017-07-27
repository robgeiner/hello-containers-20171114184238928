# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/_global/_remote_state/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod__global__remote_state-locktable"
    region     = "us-east-1"
  }
}
