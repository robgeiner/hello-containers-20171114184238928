# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-qa-remote-state-bucket"
    key        = "/qa/us-east-1/_core/vpc/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_qa_us-east-1__core_vpc-locktable"
    region     = "us-east-1"
  }
}
