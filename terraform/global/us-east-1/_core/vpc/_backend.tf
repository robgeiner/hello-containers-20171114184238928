# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-global-remote-state-bucket"
    key        = "/global/us-east-1/_core/vpc/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_global_us-east-1__core_vpc-locktable"
    region     = "us-east-1"
  }
}
