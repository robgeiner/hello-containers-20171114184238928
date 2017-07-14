# Backend config, don't change

terraform {
  backend "s3" {
    bucket     = "cognitive-devops-qa-remote-state-bucket"
    key        = "/qa/us-west-2/_core/bastion/terraform.tfstate"
    lock_table = "terraform-cognitive-devops-_qa_us-west-2__core_bastion-locktable"
    region     = "us-east-1"
  }
}
