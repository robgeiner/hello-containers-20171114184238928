# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-dev-remote-state-bucket"
    key        = "/dev/_global/route53/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_dev__global_route53-locktable"
    region     = "us-east-1"
  }
}
