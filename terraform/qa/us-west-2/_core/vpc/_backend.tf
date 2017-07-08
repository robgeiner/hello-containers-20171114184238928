# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "sun-b2c-devops-qa-remote-state-bucket"
    key        = "/qa/us-west-2/_core/vpc/terraform.tfstate"
    lock_table = "terraform-sun-b2c-devops-_qa_us-west-2__core_vpc-locktable"
    region     = "us-east-1"
  }
}
