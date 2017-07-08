# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "sun-b2c-devops-qa-remote-state-bucket"
    key        = "/qa/_global/route53/terraform.tfstate"
    lock_table = "terraform-sun-b2c-devops-_qa__global_route53-locktable"
    region     = "us-east-1"
  }
}
