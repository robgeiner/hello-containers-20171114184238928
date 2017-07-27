# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/_global/iam/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod__global_iam-locktable"
    region     = "us-east-1"
  }
}
