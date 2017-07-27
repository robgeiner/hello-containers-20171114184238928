# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-prod-remote-state-bucket"
    key        = "/prod/_global/route53/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_prod__global_route53-locktable"
    region     = "us-east-1"
  }
}
