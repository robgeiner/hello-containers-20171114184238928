# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-global-remote-state-bucket"
    key        = "/global/_global/_remote_state/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_global__global__remote_state-locktable"
    region     = "us-east-1"
  }
}
