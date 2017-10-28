# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-tools-remote-state-bucket"
    key        = "/tools/us-east-1/_core/vpc/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_tools_us-east-1__core_vpc-locktable"
    region     = "us-east-1"
  }
}
