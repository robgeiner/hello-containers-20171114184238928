# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-global-remote-state-bucket"
    key        = "/global/_global/route53/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_global__global_route53-locktable"
    region     = "us-east-1"
  }
}
