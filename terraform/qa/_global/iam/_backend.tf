# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-qa-remote-state-bucket"
    key        = "/qa/_global/iam/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_qa__global_iam-locktable"
    region     = "us-east-1"
  }
}
