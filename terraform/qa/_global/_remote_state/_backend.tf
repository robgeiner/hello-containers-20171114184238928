# backend config, don't change
terraform {
  backend "s3" {
    bucket = "sun-b2c-devops-qa-remote-state-bucket"
    key = "/qa/_global/_remote_state//terraform.tfstate"
    lock_table = "terraform-sun-b2c-devops-_qa__global__remote_state_-locktable"
    region = "us-east-1"
  }
}
